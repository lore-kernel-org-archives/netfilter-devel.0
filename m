From: paridhi bansal <paridhibansal@yahoo.com>
Subject: Problem with IPtables/Netfilter hooks
Date: Tue, 18 Feb 2003 03:40:34 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218114034.47859.qmail@web10802.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!!

I am a newbie to iptables...I was trying to understand
the hooks defined in netfilter.With natting enabled,
every pkt shld ideally come to Prerouting hook and
then only move to input hook if it is for local m/c
itself or forward hook if it is to be forwardedand
finally to postrouting..
This is what i have understood..and i hope this is
correct..If not,,pls correct me and give ur comments..

But my analysis of pkts says that sometimes, the pkts
meant for the local machine come directly to the input
hook rather than the prerouting hook..Is it
right?????Is yes, why/when does this happen??If no,
can what can be the case when this happens??

Paridhi


__________________________________________________
Do you Yahoo!?
Yahoo! Shopping - Send Flowers for Valentine's Day
http://shopping.yahoo.com
