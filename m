Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3598152178
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724313504; cv=none; b=rn9fcIen6Mvwt2ymfiD/fMajoDKz+iRZIVh0i271/7R+i8TzcHl13mjut3eVotgZCCcVeNHY5kgivmasXAZhU3R25WmY2/sX5fBdXv/gWKS9hTLSJj9r+miPttpRWZ3dajOKaPcK1D10cr9jH9EbKy/Tem/eX8/XdBT3NWjzcvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724313504; c=relaxed/simple;
	bh=M78dDH2Lv5gAbPiL85tJxK3F4eYd70NNmNQ2oSscdOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qjXn9wH58LhbV1BbJSPLAaBNUtJOQMzXONr6JvuKU2l3FQMmpN1emG2bB8PpC/3ArwPpZ/tmMEG2lsjvqjPP8mCqYesxBdB1iZaqUlyp3Y1KtVc0Dj7ZukoI0h1mmcalf8SpN9q3wgQJ0hy1RsCRO0OYiZ5RGijuRAcNCqxGeoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=h7KKx90P; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="h7KKx90P"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5334e41c30bso514718e87.0
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 00:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1724313500; x=1724918300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnX6FjUIWpzD8kqC9V27AIE0s5MyIjBt5cBluqxEzzc=;
        b=h7KKx90PMOHrw1zNIvIq4GpHPH7ns+gTrfp65M2qNTHq5luesWNkG+aG9HfZUFEBB7
         65041tLcwTvvYy2GyvGkWV8xNP+uvY0b5saBiiaVTPQwnS7q5p7oKO4vzEE8vBpBCwb+
         SjTyKmBJPctB2IgGktpv+HdFTAxU8b2n4Xv09uBjOFuBlOnkVBmmnx5+McoBXEa/LbQi
         0Q0YbZaRYyW0OyeoiuustcL6mvvdbzSB2kBqxDkIiM/8QViaDZnE5Za1Yz/0ZwOlVR66
         ltGuTwx1670a7Die1fRfXaZfytn4Co4C7NaTm6pEK+q/Qrcelx+ZwVcqd+rBC/RXURxu
         IADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724313500; x=1724918300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnX6FjUIWpzD8kqC9V27AIE0s5MyIjBt5cBluqxEzzc=;
        b=OJSKIuNqR4c17v27NfYOuC16itmq+8OvMRA1O4UE3S1CUE6uHsYgmICGZ/MmHqwm3p
         L6vPpydulM+XQQpB3b11J7JTelbvuq7U7YTxhMTmMarIpKAUpGeCFKY6aVYZUZ+EYEsL
         fwVOwTE+rxmIPTCFrJhkZfCrshgZLMG81896VDChIRc25qaDEVwzwnoN9xnN4yqizZnl
         r+aiQ+VG1zFaXLKRnQy25L3rG/M50hDqGBBOPHHq8SUqWbxX61d0U44AQgPNjZxPV4iG
         NVbG8qT0FGjXJgar3Mq+BnZuj2OJhKoGaTCvDmG65gucAQ+lynPDogMhpXimYXkI0vc9
         DC2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgfzcSxvB7POXPFvxWXz9VGA+JO7emCSV2zpqS/ib6ynmoY+t10heEvaf+2f7BEzqj23xPG5zJelaBALb9UqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzjDm/5/mRj6X0FF3mwTOpXTsAyW+2hZZtr5pf5u27Nl/2mZOt
	4fdYN8KTwn+4GdlFMA6mbPiEV+RgioDhSSif69fmmrb+Kg7wHajUixL4aQqQ+hD8xRIuOAAcD/D
	PyVHijGagCwBCQPH2kn4B+pbfMce1rLcdqWlwyg==
X-Google-Smtp-Source: AGHT+IHqRxXYm+H2Y+i5xzzY2IR+Nh6H8VShsmzm7UrXJCf65rsBntbXTU1CGj0TiGUJ3jrIhNx6F4PixK+Mw98vPfI=
X-Received: by 2002:a05:6512:3f05:b0:52f:c27b:d572 with SMTP id
 2adb3069b0e04-533485c0526mr2735846e87.59.1724313499001; Thu, 22 Aug 2024
 00:58:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620113527.7789-1-changliang.wu@smartx.com>
 <CALHBjYFn_qB=Oo3TTg0znOnNz9rX5jP+eYSZbatAN94ys8Tzmw@mail.gmail.com> <ZsOTMHeMPgtjU6ZZ@calendula>
In-Reply-To: <ZsOTMHeMPgtjU6ZZ@calendula>
From: Changliang Wu <changliang.wu@smartx.com>
Date: Thu, 22 Aug 2024 15:58:07 +0800
Message-ID: <CALHBjYH-=fHYzx8Qd=ae_Q1Qtsnt6hiVOxbW-rfPkbQAUCak+w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: support CTA_FILTER for flush
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index fd2d002..18d941b 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -68,9 +68,5 @@ int __build_filter_dump(struct nfnlhdr *req, size_t size,
 int __build_filter_flush(struct nfnlhdr *req, size_t size,
                        const struct nfct_filter_dump *filter_dump)
 {
-       if (filter_dump->set & (1 << NFCT_FILTER_DUMP_TUPLE)) {
-               errno =3D ENOTSUP;
-               return -1;
-       }
        return nfct_nlmsg_build_filter(&req->nlh, filter_dump);
 }
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 7e7aef4..50a1c7c 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -11,6 +11,7 @@ check_PROGRAMS =3D expect_dump expect_create
expect_get expect_delete \
               conntrack_dump_filter \
               conntrack_dump_filter_tuple \
               conntrack_flush_filter \
+              conntrack_flush_filter_tuple \
               ctexp_events

 conntrack_grp_create_SOURCES =3D conntrack_grp_create.c
@@ -46,6 +47,9 @@ conntrack_flush_LDADD =3D ../src/libnetfilter_conntrack.l=
a
 conntrack_flush_filter_SOURCES =3D conntrack_flush_filter.c
 conntrack_flush_filter_LDADD =3D ../src/libnetfilter_conntrack.la

+conntrack_flush_filter_tuple_SOURCES =3D conntrack_flush_filter_tuple.c
+conntrack_flush_filter_tuple_LDADD =3D ../src/libnetfilter_conntrack.la
+
 conntrack_events_SOURCES =3D conntrack_events.c
 conntrack_events_LDADD =3D ../src/libnetfilter_conntrack.la

diff --git a/utils/conntrack_flush_filter_tuple.c
b/utils/conntrack_flush_filter_tuple.c
new file mode 100644
index 0000000..f2bf558
--- /dev/null
+++ b/utils/conntrack_flush_filter_tuple.c
@@ -0,0 +1,61 @@
+#include <arpa/inet.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+static int cb(enum nf_conntrack_msg_type type, struct nf_conntrack *ct,
+              void *data) {
+  char buf[1024];
+
+  nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT,
+                NFCT_OF_SHOW_LAYER3 | NFCT_OF_TIMESTAMP);
+  printf("%s\n", buf);
+
+  return NFCT_CB_CONTINUE;
+}
+
+int main(void) {
+  int ret;
+  struct nfct_handle *h;
+
+  h =3D nfct_open(CONNTRACK, 0);
+  if (!h) {
+    perror("nfct_open");
+    return -1;
+  }
+  struct nfct_filter_dump *filter_dump =3D nfct_filter_dump_create();
+  if (filter_dump =3D=3D NULL) {
+    perror("nfct_filter_dump_alloc");
+    return -1;
+  }
+
+  struct nf_conntrack *ct;
+  ct =3D nfct_new();
+  if (!ct) {
+    perror("nfct_new");
+    return 0;
+  }
+
+  nfct_set_attr_u8(ct, ATTR_ORIG_L3PROTO, AF_INET);
+  nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
+  nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_DST, inet_addr("192.168.1.1"));
+  nfct_filter_dump_set_attr(filter_dump, NFCT_FILTER_DUMP_TUPLE, ct);
+
+  nfct_callback_register(h, NFCT_T_ALL, cb, NULL);
+  ret =3D nfct_query(h, NFCT_Q_FLUSH_FILTER, filter_dump);
+
+  nfct_filter_dump_destroy(filter_dump);
+
+  printf("TEST: get conntrack ");
+  if (ret =3D=3D -1)
+    printf("(%d)(%s)\n", ret, strerror(errno));
+  else
+    printf("(OK)\n");
+
+  nfct_close(h);
+
+  ret =3D=3D -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
+}

Thank you for your reply.

Here is an example patch for conntrack_flush_filter_tuple above.

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2024=E5=B9=B48=E6=9C=8820=
=E6=97=A5=E5=91=A8=E4=BA=8C 02:47=E5=86=99=E9=81=93=EF=BC=9A
>
> Please, provide an example program for libnetfilter_conntrack.
>
> See:
>
> commit 27f09380ebb0fc21c4cd20070b828a27430b5de1
> Author: Felix Huettner <felix.huettner@mail.schwarz>
> Date:   Tue Dec 5 09:35:16 2023 +0000
>
>     conntrack: support flush filtering
>
> for instance.
>
> thanks
>
> On Thu, Jul 11, 2024 at 01:40:02PM +0800, Changliang Wu wrote:
> > PING
> >
> >
> > Changliang Wu <changliang.wu@smartx.com> =E4=BA=8E2024=E5=B9=B46=E6=9C=
=8820=E6=97=A5=E5=91=A8=E5=9B=9B 19:35=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > From cb8aa9a, we can use kernel side filtering for dump, but
> > > this capability is not available for flush.
> > >
> > > This Patch allows advanced filter with CTA_FILTER for flush
> > >
> > > Performace
> > > 1048576 ct flows in total, delete 50,000 flows by origin src ip
> > > 3.06s -> dump all, compare and delete
> > > 584ms -> directly flush with filter
> > >
> > > Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
> > > ---
> > >  net/netfilter/nf_conntrack_netlink.c | 9 +++------
> > >  1 file changed, 3 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_=
conntrack_netlink.c
> > > index 3b846cbdc..93afe57d9 100644
> > > --- a/net/netfilter/nf_conntrack_netlink.c
> > > +++ b/net/netfilter/nf_conntrack_netlink.c
> > > @@ -1579,9 +1579,6 @@ static int ctnetlink_flush_conntrack(struct net=
 *net,
> > >         };
> > >
> > >         if (ctnetlink_needs_filter(family, cda)) {
> > > -               if (cda[CTA_FILTER])
> > > -                       return -EOPNOTSUPP;
> > > -
> > >                 filter =3D ctnetlink_alloc_filter(cda, family);
> > >                 if (IS_ERR(filter))
> > >                         return PTR_ERR(filter);
> > > @@ -1610,14 +1607,14 @@ static int ctnetlink_del_conntrack(struct sk_=
buff *skb,
> > >         if (err < 0)
> > >                 return err;
> > >
> > > -       if (cda[CTA_TUPLE_ORIG])
> > > +       if (cda[CTA_TUPLE_ORIG] && !cda[CTA_FILTER])
> > >                 err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_=
ORIG,
> > >                                             family, &zone);
> > > -       else if (cda[CTA_TUPLE_REPLY])
> > > +       else if (cda[CTA_TUPLE_REPLY] && !cda[CTA_FILTER])
> > >                 err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_=
REPLY,
> > >                                             family, &zone);
> > >         else {
> > > -               u_int8_t u3 =3D info->nfmsg->version ? family : AF_UN=
SPEC;
> > > +               u8 u3 =3D info->nfmsg->version || cda[CTA_FILTER] ? f=
amily : AF_UNSPEC;
> > >
> > >                 return ctnetlink_flush_conntrack(info->net, cda,
> > >                                                  NETLINK_CB(skb).port=
id,
> > > --
> > > 2.43.0
> > >
