From: "scott comer (sccomer)" <sccomer@cisco.com>
Subject: Re: How many rules were supported iptables?
Date: Thu, 26 Oct 2006 07:39:42 -0500
Message-ID: <4540AC8E.6050007@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090903030209040907000402"
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

This is a multi-part message in MIME format.
--------------090903030209040907000402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

in our application, a sccp specific gateway, users outside the firewall 
authenticate using secure web browser, then we open 3 ports for them by 
inserting rules into a subchain of the input chain. in trials we could 
authenticate a max of 10,281 users (30,843 rules). after that the system 
hangs.

we are using kernel  2.6.16-1.2115_FC4 and iptables 1.3.5.

we did not have time to investigate the exact cause of the hang. i have 
no idea how big the ruleset was. how does one find that out?

scott out


--------------090903030209040907000402--
