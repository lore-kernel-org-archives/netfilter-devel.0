From: Borja Pacheco <bpacheco@acisa.es>
Subject: [Fwd: Bug in math time?]
Date: Tue, 15 Mar 2005 16:12:44 +0100
Message-ID: <1110899564.9801.22.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
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

Dear all,

I've found my mistake... i should use datestop instead of timestop.
I am so sorry... 

--------- Mensaje reenviado --------
De: Borja Pacheco <bpacheco@acisa.es>
Para: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Asunto: Bug in math time?
Fecha: Tue, 15 Mar 2005 16:07:09 +0100
Dear all, 

is this a bug into the syntax parser of the match module time?

/usr/local/sbin/iptables -t mangle -I _Od172.16.11.8S170777c0 1 -m time
--timestop 2005:03:15:15:59:35 -j RETURN
iptables v1.3.1: invalid time `2005:03:15:15:59:35' specified, should be
HH:MM format
Try `iptables -h' or 'iptables --help' for more information.

If it's not, could anybody tell me why am I wrong?

Best regards
