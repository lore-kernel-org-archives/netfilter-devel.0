From: John <jfastabe@up.edu>
Subject: Iptables extension loading error
Date: Wed, 25 Aug 2004 13:12:06 +0000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <412C9026.6050703@up.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I am having trouble getting an iptables extension to work. I compile the 
shared library with the commands,

$ gcc -02 -Wall -Wunused -I /root/iptables/include/ -fPIC -o 
libipt_CHANGEIP.o -c                   libipt_CHANGEIP.c

$ ld -shared -o libipt_CHANGEIP.so libipt_CHANGEIP.o

The above commands give no errors, but when I try to run iptables with 
my new target extension i get the following error.

$ iptables iptables -I INPUT -j CHANGEIP
iptables v1.2.9: Couldn't load target `CHANGEIP'

I know the module is loaded correctly because when I remove the module I 
get a different error and the shared library is also in the correct 
directory because when i move it i get a different error then this.  I 
am at a loss for what I should start to do to look for this error.  
Below is the code to my shared library and module.  If anyone could give 
me advice on where to start looking to fix this problem that would be 
greatly appreciated.  The system I am using is,

Linux nitbit 2.4.22-gentoo-r5 #4 SMP Tue Jan 20 01:33:31 UTC 2004 i686 
Intel(R) Celeron(R) CPU 2.30GHz GenuineIntel GNU/Linux

If more information is needed to help please let me know thank you for 
your time,
john

/* Shared library add-on to iptables to add CHANGEIP target support.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <netinet/in.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include "ipt_CHANGEIP.h"

#define NOCLOBBER 0
#define CLOBBER   1

/* Function that prints out usage message */
static void
help(void)
{
    printf(
     "ChangeIP target v \n"
     "     --dip     \tip \t\t Change destination IP\n"
     "     --sip     \tip \t\t Change source IP\n"
     "     --continue\t   \t\t Let packet continue traversal\n"
     "\n");
}

static struct option opts[] = {
    {"dip", 1, 0, '1' },
    {"sip", 1, 0, '2' },
    {"clobber",0,0,'3'},
    { 0 }
};

static void init
(struct ipt_entry_target *t , unsigned int *nfcache ){
    struct ipt_changeip_target_info *ipinfo =
               (struct ipt_changeip_target_info*)t->data;
    printf("hi\n");
    ipinfo->clobber = NOCLOBBER;
    ipinfo->dip = NULL;
    ipinfo->sip = NULL;

 }



static int parse(int c, char **argv, int invert,
         unsigned int *flags,
         const struct ipt_entry *entry,
         struct ipt_entry_target **target)
{          printf("hello\n");
    struct ipt_changeip_target_info *ipinfo =
                     (struct ipt_changeip_target_info *)(*target)->data;

    //if(entry->ip.proto != IPT_IP)
    //    exit_error(PARAMETER_PROBLEM, "Needs to be an ip packet");
    switch (c){
    case '1':
        if(*flags) exit_error(PARAMETER_PROBLEM,
            "Only one destination ip allowed");
        ipinfo->dip = optarg;
                //inet_aton(optarg, ipinfo->dip.s_addr );
        *flags =1;
            break;               
    case '2':
        if(*flags) exit_error(PARAMETER_PROBLEM,
              "Only one src ip allowed");
        ipinfo->sip = optarg;
                //inet_aton(optarg, ipinfo->sip.s_addr);
        *flags = 1;
        break;
    case '3':
         if(*flags) exit_error(PARAMETER_PROBLEM,
            "Syntax messed up");
        ipinfo->clobber = 1;
        break;

    default: return 0;
    }

    return 1;
}

static void final_check(unsigned int flags){
    if(!flags)
        exit_error(PARAMETER_PROBLEM,
            "Must have either source or destination ip to change");
   
}


static void print (const struct ipt_ip *ip,
           const struct ipt_entry_target *target,
           int numeric)
{
        printf("hello\n");
    const struct ipt_changeip_target_info *ipinfo
             = (const struct ipt_changeip_target_info *)target->data;
    printf("Changing IP");          
}

static void save(const struct ipt_ip *ip, const struct ipt_entry_target 
*target)
{

}

static struct iptables_target changeip = { NULL,
    "CHANGEIP",
    "1.2.9",
    IPT_ALIGN(sizeof(struct ipt_changeip_target_info) ),
    IPT_ALIGN(sizeof(struct ipt_changeip_target_info) ),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
        printf("hello\n");
    register_target(&changeip);
}





//and finally the module code
#include <linux/module.h>
#include <linux/skbuff.h>
#include "ipt_CHANGEIP.h"
#include <linux/netfilter_ipv4/ip_tables.h>
        
          #include <linux/kernel.h>
          #include <linux/ip.h>                  /* For IP header */
          #include <linux/netfilter.h>
          #include <linux/netfilter_ipv4.h>

MODULE_AUTHOR("John Fastabend");
MODULE_DESCRIPTION("Changes ip addresses");
MODULE_LICENSE("GPL");


static unsigned int
ipt_changeip_target(struct sk_buff **pskb,
            unsigned int hooknum,
            const struct net_device *in,
            const struct net_device *out,
            const void *targinfo,
            void *userinfo)
{
    const struct ipt_changeip_target_info *ipinfo = targinfo;
        struct sk_buff *sb = *pskb;

    if(skb_cloned(*pskb) && !(*pskb)->sk){
        struct sk_buff *nskb 
                            = skb_copy(*pskb, GFP_ATOMIC);
        if(!pskb) return NF_DROP;
        kfree_skb(*pskb);
        *pskb = nskb;
        sb->nh.iph = (*pskb)->nh.iph;
    }
   
    if( ipinfo->clobber == 0 /*NOCLOBBER*/ ){
            struct sk_buff *origskb
                     = skb_copy(*pskb, GFP_ATOMIC);
        skb_insert(origskb,*pskb);
    }
   

        sb->nh.iph->daddr = ipinfo->dip;
   
       
    sb->nh.iph->saddr = ipinfo->sip;


    return IPT_CONTINUE;
}

static int ipt_changeip_checkentry( const char *tablename,
                    const struct ipt_entry *e,
                    void *targinfo,
                    unsigned int targinfosize,
                    unsigned int hook_mask)
{
return 1;
}

static struct ipt_target ipt_changeip_reg =  { {NULL, NULL},
                        "CHANGEIP",
                        ipt_changeip_target,
                        ipt_changeip_checkentry,
                        NULL,
                        THIS_MODULE };

static int  __init init(void){
    return ipt_register_target(&ipt_changeip_reg);
}

static void __exit fini(void){
    return ipt_unregister_target(&ipt_changeip_reg);
}

module_init(init);
module_exit(fini);




PS. sorry if this email is too long I didnt have anywhere to post the 
code online.
