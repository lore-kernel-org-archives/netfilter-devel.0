From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Sat, 29 Jun 2002 12:36:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206291236.36997@henrik.marasystems.com>
References: <3D1D81F8.9080309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter-devel <netfilter-devel@lists.samba.org>
In-Reply-To: <3D1D81F8.9080309@trash.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Saturday 29 June 2002 11.46, Patrick McHardy wrote:

> A CONNMARK patch will follow but currently CONNMARK doesn't apply
> clean against 2.4.18/2.4.19-pre10 ..

Note: There is two versions of the CONNMARK patch. The one in extra 
applies if you are using the new_nat patch, the one on old_nat if 
not.

Your last posting did stir up some discussion on how to deal with 
this. Adding a "terminate" option to each and every of these 
psuedo-targets is clearly not the way to go, and only cover a very 
small subset of what is needed.

I proposed adding a new class of iptables things between matches and 
targets, being neither a match for filtering or a target that 
determines the ultimate fate of the packet. The names proposed for 
these in the discussion was modifiers or actions.

The implementation of these can be done without needing to change the 
kernel iptables API by simply piggying back on the match list in the 
table structure. The modifiers/actions need to register themselves as 
a match, and for compability with old rulesets and/or userspace tools 
as a target as well..

The userspace tools need to have a new option for calling a 
modifier/action. These should clearly be separated from matches.

So the question to the Netfilter core team is if it would be OK to add 
a new option and "module class" to the userspace tools, and have the 
existing IPT_CONTINUE targets dual-register as both a target and a 
match. I can try to whip something together if this is seen as 
something acceptable. Should be fully backwards/forward compatible 
with existing rulesets with only a minimal amount of code 
duplication. The only compability issue is that if you make use the 
new feature then you cannot go back to a older userspace or kernel..

Regards
Henrik
