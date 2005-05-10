From: Amin Azez <azez@ufomechanic.net>
Subject: Re: 3896 pom-ng broken
Date: Tue, 10 May 2005 17:05:07 +0100
Message-ID: <4280DBB3.9070905@ufomechanic.net>
References: <d5q4mb$fmo$1@sea.gmane.org> <20050510154354.GB28833@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050510154354.GB28833@linuxace.com>
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

Phil Oester wrote:

>On Tue, May 10, 2005 at 12:15:19PM +0100, Amin Azez wrote:
>  
>
>>This change
>>
>>http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/Netfilter_POM.pm?rev=3896&r1=3820&r2=3896
>>
>>breaks pom-ng for me, such that it fails to apply most of the pom 
>>patches because 2.6.11 seems to be the wrong source version.
>>    
>>
>Perhaps this was intentional...which specific patches don't work, and did you verify
>the 'Requires' statement in the info file fits your kernel?
>  
>
conntrack-event-api/info
Title: conntrack event API
Author: Pablo Neira <pablo@eurodev.net>
Status: Testing
Repository: extra
Requires: linux >= 2.6.11

I was patching 2.6.11.7

Amin
