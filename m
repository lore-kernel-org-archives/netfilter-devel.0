From: "allug4me allug4me" <allug4me@gmail.com>
Subject: SIP ALG - Marking TOS/DSCP
Date: Wed, 11 Apr 2007 12:12:34 +0530
Message-ID: <ceaf8eaa0704102342j5df5a98clc32a7d99c4cb8329@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I am developing a module for a linux router. All the packets from LAN
to WAN are natted. I am using linux 2.6.18.2 kernel. Hence for SIP/RTP
packets from LAN to pass through I am using SIP Protocol Support of
Netfilter by enabling CONFIG_IP_NF_SIP as module.

The module I am developing needs to  mark the SIP, RTP and RTCP
packets with TOS/DSCP in IP Header and COS in the VLAN header.

Can anyone please help me to achieve this task?

Any pointers like documentation/suggestions to achieve this are
greatly appreciated.

Thank you very much for your help.

Best Regards,
marc
