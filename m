From: Nagaraj G <gnraj@teneoris.com>
Subject: Re: Help needed on standalone nat for opening new ports inside the
	code
Date: Sun, 15 Feb 2004 10:29:04 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076821144.13168.39.camel@localhost.localdomain>
References: <1076755824.13168.10.camel@localhost.localdomain>
	 <402E03C4.20007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <402E03C4.20007@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks for the reply

I am not using the max_expected field as I am only registering NAT and
not CONN_TRACK module as mine is a standalone NAT and I don't have
connections to manage since each packet is a new one for me on a
different connection.

Here is the registration code for the NAT Helper module. It's not that
every time I get error. I get success sometimes from the expect_related
call; but still the packets from the remote host never come in unless a
port-forward rule is set-up.

One more thing. I use ip_conntrack_change_expect to allocate a new port
for my data mangling.

Please let me know what could be wrong in this code or in something else
I might be doing wrong.

Regards,
GNR


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

                ret = ip_conntrack_expect_related(ct, newExp);
                if(ret)
                {
                        DEBUGP("expect_related returned error for 5060
in %d\n", ret);
                }

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
        NULL /*My_Nat_Expected*/                        /* expectfn */
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
        printk("ip_nat_sip: ERROR registering\n");
        
        fini();
        
        return ret;
    }

}


On Sat, 2004-02-14 at 16:47, Patrick McHardy wrote:
> Nagaraj G wrote:
> > Hello,
> > 
> > I am writing a new netfilter application module where-in I have to
> > mangle each and every packet. So, I have made the module as a standalone
> > NAT with NAT_ALWAYS flag defined.
> > 
> > ...
> >
> > I tried doing ip_conntrack_expect_related(). But it fails with -16
> > (EBUSY).
> 
> EBUSY is returned when max_expected is not set and the expectation
> clashes with existing ones. My guess is that you haven't initialized
> the mask of the expectation properly. If that's not it, please post
> the relevant sections of code, that makes it easier for people to help.
> 
> Regards,
> Patrick
