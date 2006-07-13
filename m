From: "manish Jamwal" <manish.jamwal@gmail.com>
Subject: what is the iptable command on shell to enable ping from DMZ host
	to Router-----PLEASE HELP
Date: Thu, 13 Jul 2006 13:23:17 +0530
Message-ID: <a919cbc70607130053n66eaa7bas9bfacf60329c48b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi
what is the iptable command on shell to enable ping from DMZ host to Router.
I have executed this command on shell

iptables -A INPUT -i ixp0.2 -p icmp --icmp-type echo-reply -j ACCEPT

But still not able to ping from DMZ host to router
