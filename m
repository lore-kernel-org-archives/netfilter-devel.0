From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Tue, 02 Jul 2002 15:32:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D21AB54.2000701@trash.net>
References: <3D1D81F8.9080309@trash.net> <200206291236.36997@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>On Saturday 29 June 2002 11.46, Patrick McHardy wrote:
>
>>A CONNMARK patch will follow but currently CONNMARK doesn't apply
>>clean against 2.4.18/2.4.19-pre10 ..
>>
>
>Note: There is two versions of the CONNMARK patch. The one in extra 
>applies if you are using the new_nat patch, the one on old_nat if 
>not.
>
thanks, so it was my mistake :)
i also need a terminating CONNMARK, but i guess i'm going to wait with
it until it's clear where this is going ..

>
>Your last posting did stir up some discussion on how to deal with 
>this. Adding a "terminate" option to each and every of these 
>psuedo-targets is clearly not the way to go, and only cover a very 
>small subset of what is needed.
>

also at least i do not plan do something like that :) you're right of
course, the terminate option to MARK was just something i needed now ..

>
>
>I proposed adding a new class of iptables things between matches and 
>targets, being neither a match for filtering or a target that 
>determines the ultimate fate of the packet. The names proposed for 
>these in the discussion was modifiers or actions.
>

I like the idea very much. The name 'actions' would be better in my
opinion, LOG f.e. doesn't sound like a modifier.

>
>
>The implementation of these can be done without needing to change the 
>kernel iptables API by simply piggying back on the match list in the 
>table structure. The modifiers/actions need to register themselves as 
>a match, and for compability with old rulesets and/or userspace tools 
>as a target as well.
>
>The userspace tools need to have a new option for calling a 
>modifier/action. These should clearly be separated from matches.
>
>So the question to the Netfilter core team is if it would be OK to add 
>a new option and "module class" to the userspace tools, and have the 
>existing IPT_CONTINUE targets dual-register as both a target and a 
>match. I can try to whip something together if this is seen as 
>something acceptable. Should be fully backwards/forward compatible 
>with existing rulesets with only a minimal amount of code 
>duplication. The only compability issue is that if you make use the 
>new feature then you cannot go back to a older userspace or kernel..
>
>
So all IPT_CONTINUE targets would need to be changed to register as a
module too .. if you need some help doing the silly-work just drop me
a mail ..

Bye
Patrick
