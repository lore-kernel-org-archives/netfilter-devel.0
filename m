From: Sumit Pandya <sumit@elitecore.com>
Subject: Re : Re: Logging conntrack with ip_conntrack_destroyed
Date: Wed, 11 Jun 2003 19:22:13 +0530 (GMT+05:30)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <941489777.1055339533302.JavaMail.root@mailhost.elitecore.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=941500524.1055339533291.JavaMail.root.mailhost.elitecore.com
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--941500524.1055339533291.JavaMail.root.mailhost.elitecore.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Harald,
   Here is my code. I avoided sending code in previous mail is just in the good sense of mail size.
    I know this code is not proper and can crash if someone delete the file in between module load and unload operation and after file deletion, module try to write_log. Infect this I wrote for the same purpose of what presently ipt_ACCOUNT is under discussion. I loved approach of /dev/accounting, Alternative of that was circular buffer in the same way of printk-buffer. I'm definitely not going to use file operation now but still I'm concern to know reason for kernel-oops.
   Also this list has got many request of per connection accounting support. Are you interested to support such a development? Could you take this RFP for the developers concern?
Thanks,
-- Sumit
P.S. Whenever I'm hopeless, Harald is there ;)

On Wed, Jun 04, 2003 at 01:27:11PM +0530, Sumit Pandya wrote:
> Hi All,
>     I written a kernel module which registers hook for
> ip_conntrack_destroyed. Purpose of this module is to log finish connection
> as opposed to logging every packet of a connection provided by presently
> netfilter targets (U)LOG. The module causes kernel __OOPS__ while it issues
> fileP->f_op->write. I'm using kernel 2.4.20 from kernel.org.

maybe you should accompany the sourcecode of your ipt_CONNLOG module in
order to enable us to respond in any qualified manner?



--941500524.1055339533291.JavaMail.root.mailhost.elitecore.com
Content-Type: text/plain; name=ipt_CONNLOG.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ipt_CONNLOG.c

/* 
   This is an conntrack extension loadable kernel module that 
   write finished connections from inside the Linux kernel.

   Original version By Bryan Henderson, bryanh@giraffe-data.com .

   I compiled this with:

   gcc -c filewrite.c -I/usr/src/linux/include -DMODULE -D__KERNEL__ 

   on the resulting It creates the file with name supplied in MODULE_PARM

*/

#include <linux/module.h>

#include <linux/errno.h>
#include <linux/fs.h>
#include <asm/uaccess.h>  /* For get_fs() */

#include <linux/skbuff.h>
#include <linux/ip.h>
#include <net/checksum.h>

#include <linux/netfilter_ipv4/ip_conntrack.h>
#include <linux/netfilter_ipv4/ip_tables.h>
//#include <linux/netfilter_ipv4/ipt_CONNLOG.h>

#if 1 /* control */
  #define DEBUG(format,args...) printk(KERN_DEBUG "ipt_CONNLOG:"format,##args)
#else
  #define DEBUG(format,args...)
#endif


void (*ip_conntrack_prev_destroyed)(struct ip_conntrack *conntrack) = NULL;
static struct file * fileP;
static char*     fname;
MODULE_PARM(fname, "s");

static void __exit fini(void)
{
    if (!IS_ERR(fileP)) {
        filp_close(fileP, NULL);
    }

    ip_conntrack_destroyed = ip_conntrack_prev_destroyed;
    return;
}

static int
write_log(const char* buffer,
	int buffsize)
{
    ssize_t rc=buffsize;
    mm_segment_t oldfs;

    //fileP->f_pos = 0;
    /* As the write operation for this file gets the 
       the data to write from the user's address space (fs),
       we must switch fs to be the kernel address space
       while we do this write, and then restore it afterwards.
    */
    DEBUG("Calling filesystem write %s\n", buffer);
    oldfs = get_fs();
    set_fs(get_ds());

    rc = fileP->f_op->write(fileP, buffer, buffsize, &fileP->f_pos);

    set_fs(oldfs);

    if (rc < 0) {
        printk("%s: filesystem driver's write() operation for "
               "returned errno %d.\n", __FUNCTION__, -rc);
    } else if (rc != buffsize) {
        printk("%s: write returned only %d bytes instead of %d.\n",
               __FUNCTION__, rc, buffsize);
    } else
        DEBUG("%s: write was successful.\n", __FUNCTION__);

    return 0;
}

static int	open_log(void)
{
int	error=0;

    fileP = filp_open(fname, O_CREAT|O_APPEND, 0644);

    if (IS_ERR(fileP)) {
        error = -PTR_ERR(fileP);
        DEBUG("%s: error opening file.  errno=%d\n", __FUNCTION__, error);
	goto out;
    } else {
        DEBUG("%s: File successfully opened, with file pointer at %p\n",
               __FUNCTION__, fileP);

        if (!fileP->f_op) {
            printk("%s: File has no file operations registered!\n",
                   __FUNCTION__);
	    error = (-EIO);
	    goto out_err;
	} else {
	    /*
            ssize_t (*writeOp)
                (struct file *, const char *, size_t, loff_t *) = 
                fileP->f_op->write;
            */
            if (fileP->f_op->write == NULL) {
                printk("%s: File has no write operation registered!\n",
                       __FUNCTION__);
		error = (-EIO);
		goto out_err;
	    }
        }
    }

    return error;
out_err:
        filp_close(fileP, NULL);
out:
        return error;
}

/*
 * Max length of ip-address in string XXX.XXX.XXX.XXX = 15
 * Max lenght of port# and protocol-number in string 65536 = 5
 * Max length od Application name ipt_APPCLASS = 32
 * TODO: Packets transfered and bytes transfered
 * SIZE = 15*2 + 5*2 + 5 + 32 + 1 (\n) = 78+2 SPACES-IN-FORMAT
 */
#define CONN_BUFF_SIZE	80

static void ip_conntrack_log(struct ip_conntrack *conn)
{

static char appname[] = "Elitecore";
static char conninfo[CONN_BUFF_SIZE];
struct ip_conntrack_tuple tp = conn->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
int	buffsize;

    buffsize=snprintf(conninfo, CONN_BUFF_SIZE, "%s: %u %u.%u.%u.%u:%hu %u.%u.%u.%u:%hu\n",     \
       appname, (tp).dst.protonum,                                \
       NIPQUAD((tp).src.ip), ntohs((tp).src.u.all),           \
       NIPQUAD((tp).dst.ip), ntohs((tp).dst.u.all));

    write_log(conninfo, buffsize);

    if(ip_conntrack_prev_destroyed != NULL )
	ip_conntrack_prev_destroyed(conn);

    return;
}

static int __init init(void)
{
int	error=0;

    DEBUG("%s: function entered.  Our address=%p.\n",
           __FUNCTION__, &init);
    if(fname == NULL) {
	return (-EINVAL);
    }

    error=open_log();
    if (error < 0)
	return error;

    /* FIXME: Man, this is a hack.  <SIGH> */
    if(ip_conntrack_destroyed == NULL) {
	printk(KERN_WARNING "ipt_CONNLOG: You may not get log if you load nat module after this\n");
    }
    else {
	ip_conntrack_prev_destroyed = ip_conntrack_destroyed;
    }
    ip_conntrack_destroyed = &ip_conntrack_log;

    return 0;
}


module_init(init);
module_exit(fini);
MODULE_LICENSE("GPL");



--941500524.1055339533291.JavaMail.root.mailhost.elitecore.com--
