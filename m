From: Abhishek Misra <abhishekm@cdac.in>
Subject: ip rule and ip route
Date: Mon, 26 Sep 2005 17:20:20 +0530 (IST)
Message-ID: <twig.1127735420.71041@cdac.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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


Hello,

Last week there was a mail on use of ip route.
Please let me know if there are ioctls for ip rule and ip route.

The usual ip_rt_ioctl has only this 

int ip_rt_ioctl(unsigned int cmd, void *arg)
{
        int err;
        struct kern_rta rta;
        struct rtentry  r;
        struct {
                struct nlmsghdr nlh;
                struct rtmsg    rtm;
        } req;
                                                                          
                                                  
        switch (cmd) {
        case SIOCADDRT:         /* Add a route */
        case SIOCDELRT:         /* Delete a route */
        .....
        .....

}

Thank You
