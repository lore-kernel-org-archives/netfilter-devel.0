From: Martijn Lievaart <m@rtij.nl>
Subject: Re: writing a fragmentation-needed patch
Date: Mon, 31 Mar 2003 17:10:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E885A67.3010100@rtij.nl>
References: <3E85D60D.7040304@rtij.nl> <20030330093514.GA1098@oknodo.bof.de> <3E86C399.7020209@rtij.nl> <20030331122654.GM7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>,
  Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030331122654.GM7718@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Sun, Mar 30, 2003 at 12:14:49PM +0200, Martijn Lievaart wrote:
>
>  
>
>>>- why is it a patch against REJECT, instead of a standalone target?
>>>      
>>>
>>Because it feels (felt) right. It's the only subtype of 
>>icmp-dest-unreach that is not handled in REJECT.
>>    
>>
>
>Please re-read the whole discussion about reject-with-type-13.
>  
>

/me searches archives.

Ahhh, yes I read that, but it didn't register at the time.  (And I was 
wrong, it also doesn't handle that subtype, maybe more).

>We _cannot_ change the structure layout/valid value ranges/etc of any
>target in the stable kernel series.  We always need to make sure
>backwards- and forwards-compatibility between old/new kernel and old/new
>iptables userspace.
>  
>
I see the point and had I remembered this beforehand I would have 
created a seperate target. I still may, but the solution I have now 
works for me. Effectively you are saying that the fake-source patch 
should also not have been in pom as it changes the userspace<->kernel 
interface?

OTOH, there could be an "incompatible" part of pom, for useful, but 
backwards incompatible changes. Just make clear that these are optional 
patches that will not make it into the kernel and need both a patched 
kernel and userspace. This is probably not the major goal of pom, but it 
could be a convenient repository for such patches.

>>What do you think?
>>    
>>
>
>I think the solution is to create an ICMP target, which has the
>parameters 'icmp type' and 'icmp code', where the kernel would accept
>any values.  detecting invalid icmp code/types should be done in  the
>libipt_ICMP.c userspace plugin.
>  
>

I'll have a look at the this aproach, but effectively this would just be 
a clone of libipt_REJECT with minor changes. Also it probably should not 
do the tcp-reset thingy as that is not ICMP (or think of a better 
name.... hmmmm, REJECT, no that is taken ;^>). It would give a chance to 
encode all the icmp error messages. Maybe DENY would be a better name 
although this would create major confusion for newbies.

But for me it is not all that important in the end. I have a patched 
kernel that does what I want, patch will not make pom, ok, I publish it 
somewhere else for those that want it. If I feel like it, I will have a 
look at a FRAGNEEDED and/or DENY/ICMP/Whatever target.

BTW, there does not seem to be an existing match for the DF-bit? Hmmm 
more work to do. :-)

Martijn Lievaart
