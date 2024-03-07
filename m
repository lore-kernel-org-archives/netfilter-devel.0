Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265CC126F3E;
	Thu,  7 Mar 2024 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709809405; cv=none; b=I/SULZjeXlp6zTVwOMMlEHZcq7CXueQnuZngYZ84YAeV+FvWW1y82Qxq5XqQGuPGfujxO2de//TT53d+Rm2FupYjNiX7tYFqEzS1+z/L7YvaupF832EcEcWgVUz1qlfKNdGFR+cqlNcgIqV9RQQ8gpqqFUc8wo4d0fb+cySvGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709809405; c=relaxed/simple;
	bh=lr5QfvyeHSz2s2SXgcvZ/Nkd1rlA5CoPETZmIHJ4zzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUoRtlRaezLtEeCZvOOlkoqJPWCL/4crhPetClsN/CwwvpOgw7hxlcB7l36hsSi2xMQT33IZZ+BwRK50SUP9uPrtVdSOkM0pU5NVx3YkqjLVxJeQNBMUBl0Uwm+34jZbQtHpU3lW3I2+49sb0zSfC8vuleyNDNPHgdgjqS2wfVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SITmI/nl; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SITmI/nl"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a458b6d9cfeso109923866b.2;
        Thu, 07 Mar 2024 03:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709809402; x=1710414202; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zhqtRAm8w6jqfP54KE1UneGc3bnJLKdcri76cg8nS4=;
        b=SITmI/nltixrLpAzr3HHvrWtm43Fzm/X6N3FbkvGAR8Pcm48ZgBH1BDnEfOIK9P3w8
         kD1Xq1TxXqcViulcNWsHu8uK4v9Ap3iMJHHNUSf4hPqN6cHCsJziiIzBe8SXtlhp8zyt
         GPCB+8K6Q38d3loAOLT2O1PZi1WuVsMfrhw3+AJpeNz19rKNE7waxvQm91H8HZO7NebX
         RWv2WWqYA2qw4I6gPvnnjBJEzvN6/jHy3UNjTqcIedl53mnLAIbo9llVn6HLefyvbYMd
         C7ogKOz8E4k5wNHGTuBOM8oN4My0VjSUCKkIDlnVyOgNeiH1HMD4Sm91UkVxZfH0fhUo
         L+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709809402; x=1710414202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zhqtRAm8w6jqfP54KE1UneGc3bnJLKdcri76cg8nS4=;
        b=HLaqdJUTSvFb6RWegjJrEH2SWXmvnV9v7siDLBb1yJaDLniMwAkFUx16uDQOkZaVj/
         RY8BhMoI6WPjroQ9i8XTcSCiJ7PUX7To0t2z1+wBzsmMXJe2ZfBstjc38aXwUfW6e+Y/
         owqPq2DTli0XliFR3wYIxp5H88ev0RKWiKiGuk2R527Zo+kyaazidrVd919OHsGsiUIB
         01R65UKRt/r+NuIk7Z8AqND867b53uFFdap76qVdBZy1jALLFhJX/SgTvOUahFqy64kn
         MMoELgTubZnaLmz0c+v6GRkQZlHT/yG1JkGJtZzqmZ2k2Yw8XuqF6dudC5IL53L+J3TV
         Z03g==
X-Forwarded-Encrypted: i=1; AJvYcCUNpJSwWL3pImZcEpLCcFbpNA+vijMDB8Ondezufpu4reoJIXtxrkWrClNserq2C38FKVzFiF/z7YKquTI1fZwxPuc6swVAEhbFkZt7aQG8q9wkqVzMyy1QS7KYfB3iYzl9MXcFiJ3P
X-Gm-Message-State: AOJu0YwmYws7cY/DxCOk7BWR1dQP5PbIHL9Bfn4Z+kmJmci4Gtg6SbOW
	yEoqb3xLXwDCEsZFk4CED34arcGz5IFJhGf5OOXoS5RKJz3/V98p2/+QBcV5iOgm7Ky7lAtMKwr
	aU4z2vBJKHG5yhDOLhEdZ/J+SgHc=
X-Google-Smtp-Source: AGHT+IE0fk20Kh8J3ynUyep2F2vqvTqwcWjMKAgXoycbCjRgz8BgoTwdMq29vCKsbD2kpSvWKsa7ssggNbuAjlqT1H0=
X-Received: by 2002:a17:906:135b:b0:a44:74f6:a004 with SMTP id
 x27-20020a170906135b00b00a4474f6a004mr12377807ejb.26.1709809402188; Thu, 07
 Mar 2024 03:03:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307090732.56708-1-kerneljasonxing@gmail.com> <20240307093310.GI4420@breakpoint.cc>
In-Reply-To: <20240307093310.GI4420@breakpoint.cc>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Thu, 7 Mar 2024 19:02:45 +0800
Message-ID: <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Florian,

On Thu, Mar 7, 2024 at 5:33=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Jason Xing <kerneljasonxing@gmail.com> wrote:
> > client_ip:client_port <--> server_ip:b_port
> >
> > Then, some strange skbs from client or gateway, say, out-of-window
> > skbs are sent to the server_ip:a_port (not b_port) due to DNAT
> > clearing skb->_nfct value in nf_conntrack_in() function. Why?
> > Because the tcp_in_window() considers the incoming skb as an
> > invalid skb by returning NFCT_TCP_INVALID.
>
> So far everything is as intended.
>
> > I think, even we have set DNAT policy, it would be better if the
> > whole process/behaviour adheres to the original TCP behaviour.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/netfilter/nf_conntrack_proto_tcp.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_=
conntrack_proto_tcp.c
> > index ae493599a3ef..3f3e620f3969 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1253,13 +1253,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> >       res =3D tcp_in_window(ct, dir, index,
> >                           skb, dataoff, th, state);
> >       switch (res) {
> > -     case NFCT_TCP_IGNORE:
> > -             spin_unlock_bh(&ct->lock);
> > -             return NF_ACCEPT;
> >       case NFCT_TCP_INVALID:
> >               nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > +     case NFCT_TCP_IGNORE:
> >               spin_unlock_bh(&ct->lock);
> > -             return -NF_ACCEPT;
> > +             return NF_ACCEPT;
>
> This looks wrong.  -NF_ACCEPT means 'pass packet, but its not part
> of the connection' (packet will match --ctstate INVALID check).
>
> This change disables most of the tcp_in_window() test, this will
> pretend everything is fine even though tcp_in_window says otherwise.

Thanks for the information. It does make sense.

What I've done is quite similar to nf_conntrack_tcp_be_liberal sysctl
knob which you also pointed out. It also pretends to ignore those
out-of-window skbs.

>
> You could:
>  - drop invalid tcp packets in input hook

How about changing the return value only as below? Only two cases will
be handled:

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
b/net/netfilter/nf_conntrack_proto_tcp.c
index ae493599a3ef..c88ce4cd041e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
        case NFCT_TCP_INVALID:
                nf_tcp_handle_invalid(ct, dir, index, skb, state);
                spin_unlock_bh(&ct->lock);
-               return -NF_ACCEPT;
+               return -NF_DROP;
        case NFCT_TCP_ACCEPT:
                break;
        }

Then it will be dropped naturally in nf_hook_slow().

>  - set nf_conntrack_tcp_be_liberal=3D1

Sure, it can workaround this case, but I would like to refuse the
out-of-window in netfilter or TCP layer as default instead of turning
on this sysctl knob. If I understand wrong, please correct me.

Thanks,
Jason

>
> both will avoid this 'rst' issue.
