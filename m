From: Matthias Dettling <m-dettling@gmx.de>
Subject: Reviewing a piece of code, locking questions
Date: Fri, 28 May 2004 23:46:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B7B31E.8040001@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello developers,

I have modified a patched version of "ipt_conntrack.c" for matching 
packets on the informations of a related connection that were tracked 
before. The following is the most important piece of my modification in 
the function "match".
There is to remark that the flag fields were extended to "u_int32_t" to 
take up additional flags (IPT_CONNTRACK_RELORIGSRCPORT, 
IPT_CONNTRACK_RELORIGDSTPORT, IPT_CONNTRACK_RELREPLSRCPORT, 
IPT_CONNTRACK_RELREPLDSTPORT).

modifications "ipt_conntrack.c":
static int match(.....)
{
....
/* 
###################################################################################### 
*/
    if(sinfo->flags & IPT_CONNTRACK_RELORIGSRCPORT) {
        READ_LOCK(&ip_conntrack_lock);
       
        if (!ct)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master->expectant || 
FWINV(!port_match(sinfo->rel_srcports[IP_CT_DIR_ORIGINAL][0], \ 
sinfo->rel_srcports[IP_CT_DIR_ORIGINAL][1], \ 
ntohs(ct->master->expectant->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port)), 
\ IPT_CONNTRACK_RELORIGSRCPORT))
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        READ_UNLOCK(&ip_conntrack_lock);
    }

    if(sinfo->flags & IPT_CONNTRACK_RELORIGDSTPORT) {
        READ_LOCK(&ip_conntrack_lock);
       
        if (!ct)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master->expectant || 
FWINV(!port_match(sinfo->rel_dstports[IP_CT_DIR_ORIGINAL][0], \ 
sinfo->rel_dstports[IP_CT_DIR_ORIGINAL][1], \ 
ntohs(ct->master->expectant->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port)), 
\ IPT_CONNTRACK_RELORIGDSTPORT))
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        READ_UNLOCK(&ip_conntrack_lock);
    }

    if(sinfo->flags & IPT_CONNTRACK_RELREPLSRCPORT) {
        READ_LOCK(&ip_conntrack_lock);
       
        if (!ct)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master->expectant || 
FWINV(!port_match(sinfo->rel_srcports[IP_CT_DIR_REPLY][0], \ 
sinfo->rel_srcports[IP_CT_DIR_REPLY][1], \ 
ntohs(ct->master->expectant->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port)), 
\ IPT_CONNTRACK_RELREPLSRCPORT))
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        READ_UNLOCK(&ip_conntrack_lock);
    }

    if(sinfo->flags & IPT_CONNTRACK_RELREPLDSTPORT) {
        READ_LOCK(&ip_conntrack_lock);
       
        if (!ct)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master)
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        if (!ct->master->expectant || 
FWINV(!port_match(sinfo->rel_dstports[IP_CT_DIR_REPLY][0], \ 
sinfo->rel_dstports[IP_CT_DIR_REPLY][1], \ 
ntohs(ct->master->expectant->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port)), 
\ IPT_CONNTRACK_RELREPLDSTPORT))
        {
            READ_UNLOCK(&ip_conntrack_lock);
            return 0;
        }

        READ_UNLOCK(&ip_conntrack_lock);
    }
/* 
###################################################################################### 
*/
....
}

modifications "ipt_conntrack.h":
/* 
###################################################################################### 
*/
#define IPT_CONNTRACK_RELORIGSRCPORT    0x00001000
#define IPT_CONNTRACK_RELORIGDSTPORT    0x00002000
#define IPT_CONNTRACK_RELREPLSRCPORT    0x00004000
#define IPT_CONNTRACK_RELREPLDSTPORT    0x00008000
/* 
###################################################################################### 
*/
......
struct ipt_conntrack_info
{
......
/* 
###################################################################################### 
*/
    /* Ports of the master connection, if existent */
    u_int16_t rel_srcports[IP_CT_DIR_MAX][2];
    u_int16_t rel_dstports[IP_CT_DIR_MAX][2];
/* 
###################################################################################### 
*/
......
};

Can someone look at the code to see if there are any mistakes? 
Especially the parts with locking should be reviewed because I am really 
unsure if I have locked properly. Do I need a "WRITE_LOCK" or only a 
"READ_LOCK", is "&ip_conntrack_lock" right or need I 
"&ip_conntrack_expect_tuple" or even some other locking?
This is very important because I have no SMP machine to test the code there.
For me on my i386 it works without problems.

I didn't post the userspace code because this is nearly straightforward 
and I'm almost sure that it is correct.
If it is required I will of course post the whole code.

An other question I have is if it is legal to modifiy the structure 
"ipt_conntrack_info" in "ipt_conntrack.h" or could this cause problems 
or errors?
I have added 2 arrays with the ports of the related connection for the 
matching as also extended the flag fields (see above).

If all should be OK, how can I publish the modification, that it could 
be part of later versions of iptables and the kernel, because I think it 
could be interesting for others too?

Best regards
Matthias Dettling
