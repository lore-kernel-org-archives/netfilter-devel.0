From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Mon, 1 Jul 2002 09:50:18 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020701075018.GA440@balabit.hu>
References: <3D1D81F8.9080309@trash.net> <200206291236.36997@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Patrick McHardy <kaber@trash.net>,
	netfilter-devel <netfilter-devel@lists.samba.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206291236.36997@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 29, 2002 at 12:36:36PM +0200, Henrik Nordstrom wrote:
> On Saturday 29 June 2002 11.46, Patrick McHardy wrote:
> So the question to the Netfilter core team is if it would be OK to add 
> a new option and "module class" to the userspace tools, and have the 
> existing IPT_CONTINUE targets dual-register as both a target and a 
> match. I can try to whip something together if this is seen as 
> something acceptable. Should be fully backwards/forward compatible 
> with existing rulesets with only a minimal amount of code 
> duplication. The only compability issue is that if you make use the 
> new feature then you cannot go back to a older userspace or kernel..

I for one would second a feature like this. I see a good number of places
where it could be used (the long standing missing -l option is one example)

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
