From: "wizard" <caster@postech.ac.kr>
Subject: [More Question] TIMEBLOCK
Date: Thu, 10 Oct 2002 17:37:50 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <CKEGJOPDOMNNFIGIMICAOEGPCBAA.caster@postech.ac.kr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 I still have a question about timeblock,

 I use timeblock with crontab. and  there is some problem with this method.

 for example

 1) there is a rule that  netfiler with conntrack accept packet from
10.0.0.1 to 10.0.1.1 on the term from 6 AM to 7 AM.(on top of FORWARD chain
, there is rule for Established and Related packet ACCEPTING.

 2) there is a connection on 6:30 AM, and user continue his job with telnet
,so conntrack entry is not destroyed from timeout.

 3) When it is past 7 AM , the rule acceping telnet will be vanished by
crond , but telnet session will be survive, because of it's session and
 the rule accepting Established packet.


 so. I cannot apply drop rule immidatly for the connection  which is
accepted before , until connection entry is destory by the kernel timer.

 I want to apply drop rule to the connection still using.

 how can i do this  sustaining the Established accept rule on the top of
FORWARD chain?
