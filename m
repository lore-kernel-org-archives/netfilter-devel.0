From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Dell PE2650 with integrated Broadcom NIC and NIC hardware TCP
	checksums messes up PPTP
Date: Wed, 27 Sep 2006 11:44:52 +0300
Message-ID: <20060927084452.GB2326@edu.joroinen.fi>
References: <925A849792280C4E80C5461017A4B8A206FBCB@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: prossow@ScholarshipAmerica.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
Content-Disposition: inline
In-Reply-To: <925A849792280C4E80C5461017A4B8A206FBCB@mail733.InfraSupportEtc.com>
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

On Tue, Sep 26, 2006 at 11:30:03AM -0500, Greg Scott wrote:
>  
> Regardless, as soon as we turned off NIC hardware checksums on the Dell
> PE server, the problem went away.  I can connect from behind both
> gateways in any order I want, as often as I want, and it hasn't broken
> yet.  
>  
> This leads me to a few thoughts about Dell servers that would be
> politically unwise to share in a public forum.  :)
>  

Are you running latest firmware in the NIC ?

I had some problems with onboard TG3 NIC in IBM Blade servers, and the
problems got fixed when I upgraded the NIC firmware..

> I want to thank Patrick agian for helping us track this down, and
> hopefully this writeup can help others in similar situations.  
>  
> thanks
>  
> - Greg Scott
> 

-- Pasi
