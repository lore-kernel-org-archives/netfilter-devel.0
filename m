From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] multiple changes/fixes
Date: Fri, 27 Aug 2004 18:28:09 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040827162808.GA29915@eychenne.org>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <412F5A3C.1000704@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Aug 27, 2004 at 05:58:52PM +0200, Patrick McHardy wrote:

> Herve Eychenne wrote:

> >I tried my best not to forget anything, especially regarding global
> >coherence, synchronisation between IPv4 and IPv6 parts, or between
> >options, help messages and man pages.
> >Yet, this patch touches quite simple but multiple things, so one never
> >knows... Further reviews/testing welcome!

> Would it be possible that you split the patch into logical changes
> so it's easier to review ?

I was afraid someone would say that. Does someone know a good tool to
split patches? I think of a X11 that would enable to drag and drop
diff file portions to several new areas/patches, with an option that
would automatically create one containing only whitespace changes.

Otherwise I guess I may not have the courage to do it. :-(

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
