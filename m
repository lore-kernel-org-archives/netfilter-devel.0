From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Mon, 01 Mar 2010 03:17:35 +0100
Message-ID: <1267409855.9082.103.camel@edumazet-laptop>
References: <20100228033841.265CFF8BB0@sepang.rtg.net>
	 <1267331677.9082.46.camel@edumazet-laptop>  <4B8AB4BE.7080206@tpi.com>
	 <1267388436.9082.84.camel@edumazet-laptop>  <4B8AF877.4080001@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: timg@tpi.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4B8AF877.4080001@tpi.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le dimanche 28 f=C3=A9vrier 2010 =C3=A0 16:12 -0700, Tim Gardner a =C3=A9=
crit :

> You are right about the reaper pointer. I'd forgotten that the LRU li=
st
> was already sorted oldest to newest. Doh! I've cleaned that up some.
>=20
> This version adds the '--reap' flag and only looks at the head of the
> LRU list once per ip_reaper_freq packets.
>=20
> I also added a check that makes sure --rttl and --reap modify only th=
e
> --rcheck and --update options.
>=20
> rtg

@@ -272,6 +295,16 @@ recent_mt(const struct sk_buff *skb, const struct
xt_match_param *par)
                                break;
                        }
                }
+
+               /*
+                * Run the reaper every ip_reaper_freq packets.
+                */
+               if ((info->check_set & XT_RECENT_REAP) &&
+                   info->seconds &&

This (info->seconds) test is redundant, if you test it _once_ in
recent_mt_check()

+                   (++t->reaper_cnt >=3D ip_reaper_freq)) {
+                       t->reaper_cnt =3D 0;
+                       recent_entry_reap(t, time);
+               }
        }


ie :

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index fc70a49..66d68f3 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -294,6 +294,8 @@ static bool recent_mt_check(const struct
xt_mtchk_param *par)
        if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
            (info->seconds || info->hit_count))
                return false;
+       if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
+               return false;
        if (info->hit_count > ip_pkt_list_tot)
                return false;
        if (info->name[0] =3D=3D '\0' ||



Then, now that reaping is done as a rule option only, I am not sure we
still need the reaper_cnt logic, since you probably want ip_reaper_freq
=3D 1, or else table size will probably grow at its limit, even in non =
DOS
situation.



