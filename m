From: Nagaraj G <gnraj@teneoris.com>
Subject: Problem in NATting reply (related) connections' packets
Date: Tue, 17 Feb 2004 11:30:15 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076997615.6540.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Everyone,

I have written a NetFilter application module for handling my
application where-in every packet going out to that destination port and
coming in to that destination port has to get NATted. I don't think I
need CONN-TRACK module as I need to modify each and every packet.

I am using Linux 2.4.10 kernel.

Here is the code I use for registering to NAT and my NAT Helper
functions.

I get a call to my NAT_Help function whenever there is a packet going
out from an internal machine to an external machine on the destination
port (MY_PORT). 

I mangle the contents and create an expected connection from the remote
(external) machine back on the destination port (MY_PORT) as I get the
reply back only on this port and not on the source port of the previous
packet.

I get a call to my NAT_Expected function and I supply the IP and PORT
information of the internal client (for translation). But after that, it
just goes directly to the internal client. It does not call my NAT_Help
function at all even though I specified NAT_ALWAYS flag.

Since I have not yet de-NATted the data, the packet is rejected by the
internal client as invalid.

Even though I do the de-NATting for this packet, for all future packets,
I don't get the call to this NAT_Expected also.

Can anyone please let me know why I am facing this problem?

I just want all packets destined to MY_PORT in both directions come to
my NAT_Help function for mangling the contents.

I have tried setting the flags (during registration to only
IP_NAT_HELPER_F_ALWAYS). I have tried supplying the Linux's IP address
itself in the NAT_Expected function. But nothing helped me in getting
called to my NAT_Help function.

If I add a port-forward rule for this MY_PORT, I get called in the
reverse direction. But, this limits my functionality to only one client.

Can anyone please help?

Thanks in advance

Best Regards,

Nagaraj

=====================CODE===============================================
static 
unsigned int 
My_Nat_Help(
    struct ip_conntrack *ct,            /* Connection Tracking Data */
    struct ip_conntrack_expect *exp,    /* Connection Track Expect Data
*/
    struct ip_nat_info *info,           /* NAT Info */
    enum ip_conntrack_info ctinfo,      /* Connection Track Info */
    unsigned int hooknum,               /* Hook Number */
    struct sk_buff **pSkb               /* Packet */
    )
{
        struct ip_conntrack_expect newExpect, *newExp;

/* Mangle the packet here */
/* I use change_expect to allocate a new port */
.
.
.

/* Here I create the connection for my new incoming packet */
                DEBUGP("Setting up incoming connection\n");
                
                /* Clear Expect Structure */
                memset(&newExpect, 0, sizeof(newExpect));

                newExp = &newExpect;
                
                newExp->tuple.src.ip = htonl(pIpHdr->daddr);
                newExp->tuple.src.u.udp.port = 0;
                newExp->tuple.dst.ip = htonl(pIpHdr->saddr);
                newExp->tuple.dst.protonum = IPPROTO_UDP;
                newExp->tuple.dst.u.udp.port = MY_PORT;

                newExp->mask.src.ip = 0xFFFFFFFF;
                newExp->mask.src.u.udp.port = 0xFFFF;
                newExp->mask.dst.ip = 0xFFFFFFFF;
                newExp->mask.dst.protonum = 0xFFFF;
                newExp->mask.dst.u.udp.port = 0xFFFF;

                newExp->expectfn = NULL;

/* I fill-up my help->exp_info fields with the required parameters */

                ret = ip_conntrack_expect_related(ct, newExp);
                if(ret)
                {
                        DEBUGP("expect_related returned error %d\n",
ret);
                }

}


static 
unsigned int 
My_Nat_Expected(
    struct sk_buff **pskb,      /* Packet */
    unsigned int hooknum,       /* Hook Number */
    struct ip_conntrack *ct,    /* Connection Track Data */
    struct ip_nat_info *info    /* Nat Info */
    )
{

	/* I supply the IP and port info and call ip_nat_setup_info */
}

static struct ip_nat_helper my_ip_nat_helper_reg = 
{ 
        { NULL, NULL },
        "myname",                               /* name */
        (IP_NAT_HELPER_F_STANDALONE | IP_NAT_HELPER_F_ALWAYS),   /*
flags */
        THIS_MODULE,                               /* module */
        { { 0, { .udp = { __constant_htons(MY_PORT) } } }, /* tuple */
          { 0, { 0 }, IPPROTO_UDP } },
        { { 0, { .udp = { 0xFFFF } } },         /* mask */
          { 0, { 0 }, 0xFFFF } },
        My_Nat_Help,                           /* helper */
        My_Nat_Expected                        /* expectfn */
};


static 
void 
fini(
    void
    )
{
    ip_nat_helper_unregister(&my_ip_nat_helper_reg);
}

static 
int 
__init my_nat_init(
    void
    )
{
        int ret;

        ret = ip_nat_helper_register(&my_ip_nat_helper_reg);

    if (ret) 
    {
        printk("ERROR registering\n");
        
        fini();
        
        return ret;
    }

}
=============================CODE ENDS ==============================
