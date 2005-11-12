From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] x_tables, take 4
Date: Sat, 12 Nov 2005 11:46:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511121138300.9438@bizon.gios.gov.pl>
References: <20051103191110.GO905@sunbeam.de.gnumonks.org>
	<200511071710.56991.mbellion@hipac.org>
	<20051112101253.GB10584@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-885297174-1131792409=:9438"
Cc: Michael Bellion <mbellion@hipac.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051112101253.GB10584@sunbeam.de.gnumonks.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-885297174-1131792409=:9438
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 12 Nov 2005, Harald Welte wrote:

<CUT>

> As a second step, I want to cleanup the API for matches/targets, and
> also introduce the tlv-to-matchinfo and matchinfo-to-tlv members of
> xt_match / xt_target.  Also, the 'verdict' that is returned by targets
> needs to be removed [for multiple targets], but in a way they

Is it possible to add a match negation at the same time?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-885297174-1131792409=:9438--
