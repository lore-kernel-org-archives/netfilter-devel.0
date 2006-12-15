From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: change in behavior of OUTPUT chain reject rule in 2.6.19
Date: Fri, 15 Dec 2006 00:36:11 -0500
Message-ID: <4582344B.7090406@laurelnetworks.com>
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
2.6.18 but will take minutes to timeout under 2.6.19.  A "git bisect" 
identifies change 9d02002d2dc2c7423e5891b97727fde4d667adf1 as the 
culprit.  The change description gives no hint that this effect was 
intended.  Is this a regression?
-- 
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
