From: Jean-Yves Provost <jyppy@adsl.on.net>
Subject: conntrack timer UNREPLIED !!!
Date: 13 Mar 2003 17:27:20 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1047536841.2074.19.camel@beurre.telux.me>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi,

I'm unable to find the reason why this occurs.

I'm running an unpatched 2.4.19 kernel.

I found some reference to similar problems over a year ago but no
reference to a fix.

I've tried to replicate by applying filters mid connection or
disconnection (filter FIN, ACK, FINACK ...) cannot reproduce it.

What the current status?

tcp      6 160183 ESTABLISHED src=1.2.3.4 dst=2.3.4.5 sport=42165
dport=80 [UNREPLIED] src=2.3.4.5 dst=1.2.3.4 sport=80 dport=42165 use=1 

tcp      6 160183 ESTABLISHED src=1.2.3.4 dst=2.3.4.5 sport=42167
dport=34917 [UNREPLIED] src=2.3.4.5 dst=1.2.3.4 sport=34917 dport=42167
use=1 
