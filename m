From: Menno Smits <menno@netboxblue.com>
Subject: Simulatenous use of LOG and ULOG on 2.6.14
Date: Mon, 07 Nov 2005 16:25:18 +1000
Message-ID: <436EF34E.2030806@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Hi,

I'm trying to use the LOG and ULOG targets simultaenously on 2.6.14 but 
am having problems. This used to work on previous kernel versions.

The setup is this:

- kernel configured without the new netlink stuff:
# CONFIG_NETFILTER_NETLINK is not set
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_QUEUE=m
# CONFIG_IP_NF_TARGET_NFQUEUE is not set

- a daemon that uses the old ipulog library starts at boot time and is 
fed by several ULOG rules

- if I try and insert a LOG rule the iptables command appears to work 
but no logs go to syslog except the following message:
    ipt_LOG: not logging via system console since somebody else already
    registered for PF_INET

- if I stop the logging daemon, remove the ULOG rules and unload 
ipt_ULOG I can happily insert functional LOG rules again. However I need 
both LOG and ULOG simultaenously.

How do I make this work as before? I need to be able to use both ULOG 
and LOG at the same time. Will it work if enable 
CONFIG_NETFILTER_NETLINK and related options and port the daemon to the 
new libnetfilter_log library? I'd really prefer to not have to touch the 
daemon at this stage but will if that's the only answer.

Regards,
Menno




Scanned by the NetBox from NetBox Blue
(http://netboxblue.com/)
