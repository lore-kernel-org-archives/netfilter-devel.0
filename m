From: Thomas Andrews <tandrews@grok.co.za>
Subject: netlink socket problem
Date: Sat, 22 Oct 2005 21:22:41 +0200
Message-ID: <20051022192241.GZ20885@grok.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I hope this isn't considered off-topic. I'm trying to get some code to
talk to a netlink socket, but I keep getting this error:

    RTNETLINK answers: Invalid argument

In this example I am just trying to add a route:

-------------8<-------------------------------------------------------

int add_route(__u32 * destination, __u32 * gateway)
{
    struct rtnl_handle rth;

    struct {
        struct nlmsghdr n;
        struct rtmsg r;
        char buf[1024];
    } req;

    memset(&req, 0, sizeof(req));

    req.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));
    req.n.nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
    req.n.nlmsg_type = RTM_NEWROUTE;

    req.r.rtm_family = AF_INET;
    req.r.rtm_table = RT_TABLE_MAIN;
    req.r.rtm_protocol = RTPROT_BOOT;
    req.r.rtm_scope = RT_SCOPE_UNIVERSE;
    req.r.rtm_type = RTN_UNICAST;

    addattr_l(&req.n, sizeof(req), RTA_DST, destination, 4);
    addattr_l(&req.n, sizeof(req), RTA_GATEWAY, gateway, 4);

    if (rtnl_open(&rth,0) < 0)
        return (-1);

    if (rtnl_talk(&rth, &req.n, 0, 0, NULL,NULL,NULL) < 0)
        return (-1);

    return 0;
}

-------------8<-------------------------------------------------------

What am I doing wrong in this function ?

Many thanks,
Thomas
