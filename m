From: Nigel Clarke <nigel@forever-networks.com>
Subject: Re: need project for school
Date: Fri, 11 Oct 2002 10:26:51 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210111426.QCH20922@vmms1.verisignmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, peltco@mail.utexas.edu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Pelt <peltco@mail.utexas.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Victor, 

If you go with IP filter/tables, take a look at the cluster 
solutions. Currently it is possible to run IPfilter 
in "cluster" config using VRRP. This is an active/passive 
solution. A active/active solution might be more reasonable 
for the enterprise networks. 

In addition, take a look a the the current VPN support. I 
know I'd consider a Linux firewall over Checkpoint if 
I could get gateway to gateway VPNs working. 

Clarke 
