From: Bob Arctor <curious@pb194.luban.sdi.tpnet.pl>
Subject: Re: udp REJECT....
Date: Mon, 27 Jan 2003 14:42:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301271442.38121.curious@pb194.luban.sdi.tpnet.pl>
References: <200301270513.19862.curious@pb194.luban.sdi.tpnet.pl> <20030127074322.GA18340@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030127074322.GA18340@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 27 January 2003 08:43, Patrick Schaaf wrote:
> On Mon, Jan 27, 2003 at 05:13:19AM +0100, Bob Arctor wrote:
> > hello... i have problems with dDoS attacks, and would like to set up =
my
> > linux routers dDoS proof
>
> [SNIP]
>
> In practise, the limit match is all you need for the scenario you
> described. Find out how many UDP packets your supposed victim
> sends during normal operation, and limit to two times that.
hmm.. rather not... victim doesn't send _any_ udp packets during normal=20
operation, but starts to reject UDP packets when there is need to block t=
hem=20
on the router (thus rejecting them to router from which it doesn't want t=
o=20
have packets coming from )
so these should go to 'forward reject' queue, and be forwarded to origina=
l=20
router.... _then_ any packets coming from 'attacker' (or relay - next=20
router) should be rejected .=20


--=20
