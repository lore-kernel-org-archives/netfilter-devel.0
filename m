From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Routing decision?
Date: Mon, 15 Sep 2003 15:16:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F65BBC2.8030208@able.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1063631808-25283-109"
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

This is a multi-part message in MIME format...

------------=_1063631808-25283-109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

In paragraph 6.2 of the iptables-tutorial the following is said:
"The OUTPUT chain is used for altering locally generated packets (i.e., 
on the firewall) before they get to the routing decision.

But in paragraph 3.1, the "Traversing of tables and chains" diagram, we 
see the "Routing decision" is listed after the "Local process" and
BEFORE! the packet goes to the output chain.

So which one is right? Does the routing decision take place after or 
before the packet travels through the output chain?

Regards

-- 
Wim Ceulemans
R&D Engineer

Secure Internet Communication with aXs Guard

Able NV
Leuvensesteenweg 282 - B-3190 Boortmeerbeek - Belgium
Phone: + 32 15 50.44.00 - Fax: + 32 15 50.44.09
E-mail: wim.ceulemans@able.be



--
Security check on this e-mail has been done by aXs GUARD
(http://www.axsguard.com)


------------=_1063631808-25283-109--
