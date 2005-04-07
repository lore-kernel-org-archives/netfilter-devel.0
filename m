From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Thu, 07 Apr 2005 15:21:52 +0100
Message-ID: <42554200.3020405@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>
	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>
	<4254265F.6080607@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4254265F.6080607@eurodev.net>
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

Pablo Neira wrote:
> Amin Azez wrote:
>> It appears that pom-ng nfnetlink-ctnetlink-0.13 (ported by Pablo?) 
>> requires ct-event (although this is not listed in the pom-ng 
>> dependancies).
>>
>> Pablo, can you confirm this?
> 
> I've just merged Harald's and my port. You can get it from:
> 
> http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/

I had thought that your merge with Harald replaced 
nfnetlink-ctnetlink-0.13 on pom-ng.

After your new patch (which applies cleanly to 2.6.11) trying to compile 
libctnetlink fails on not finding nfnetlink_conntrack.h which can't be 
found in any kernel sources (patched or otherwise) but only be found in:
patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/nfnetlink_conntrack.h

Do I still need to grab any files from nfnetlink-ctnetlink-0.13 in pom-ng?

Amin
