From: "hMax Roth" <mroth2002@hotmail.com>
Subject: spoof packets.
Date: Tue, 01 Oct 2002 19:51:00 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F241hALlPBU23kRKeJ10000c626@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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



hello. Is it possible to reinject a packet into the Tcp/ip stack? I want to 
fool the stack into thinking its received a packet from xxx.xxx.xxx.xxx when 
in reality, that computer doesn't exist. ip_rcv_finish type functions aren't 
exported (grrr...). How can I do this in a module? does netfilter provide 
this functionality ? -max

_________________________________________________________________
Chat with friends online, try MSN Messenger: http://messenger.msn.com
