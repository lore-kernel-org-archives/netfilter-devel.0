From: Brad Fisher <brad@info-link.net>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 04 Jan 2006 10:36:01 -0600
Message-ID: <43BBF971.50307@info-link.net>
References: <20060104142750.GF15217@schlittermann.de>
	<Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Heiko Schlittermann <hs@schlittermann.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
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

I've also sent a couple of patches to add this functionality to Fabrice 
and the dev list.  I'd like to see it implemented at some point, 
regardless of the patch used :)  Another thing I know was an issue in 
the past for me was a restriction on which hooks the time match was 
allowed in.  I believe my most recent patch (send on 12/3/2003 i think) 
removed those restrictions and allowed it in all hooks as well as 
allowing the time range to cross the midnight boundary.  Perhaps that 
issue has been resolved in the meantime though, I haven't checked the 
code recently.  I see there have also been a few others who have sent 
patches to  the mailing list to address this issue as well.

-Brad
