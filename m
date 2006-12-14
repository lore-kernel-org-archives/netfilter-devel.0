From: Mike Accetta <maccetta-bounce@laurelnetworks.com>
Subject: change in behavior of OUTPUT chain rule in 2.6.19
Date: Thu, 14 Dec 2006 13:30:01 -0500
Message-ID: <45819829.2060806@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Between 2.6.18 and 2.6.19 (and 2.6.19.1) we've observed that a reject 
rule on the OUTPUT chain no longer causes a connection attempt to abort 
immediately with "Connection refused".  As a specific example, this rule

iptables -A  OUTPUT -p tcp --destination-port 23 \
   --destination 10.0.20.1  -j REJECT --reject-with tcp-reset

will cause a telnet connection to 10.0.20.1 to fail immediately under 
2.6.18 but will take minutes to timeout under 2.6.19.  Is this an 
intended change in functionality or a regression?  This is all using 
iptables-1.2.7a.
-- 
Mike Accetta
(mail address must be adjusted "appropriately" to reply)

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
