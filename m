Return-Path: <SRS0=GfVU=S6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634F6C43219
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 08:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2839220881
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 08:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1RdmFRP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfD1ICu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Apr 2019 04:02:50 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:38605 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfD1ICu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Apr 2019 04:02:50 -0400
Received: by mail-ed1-f54.google.com with SMTP id c1so6552745edk.5
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Apr 2019 01:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/e+LCZ73Q3kBJGbSA8LvNbG7OX30ZNqVmjoSsWRrS84=;
        b=D1RdmFRPIKW3H4hvko2go/7geNvNjQrE5ol2pgPIwfdaJtIXgqK/3EgdDmIjVhs3N3
         JETnNKqDJo6Ko6heIOsBtDtEGaCiCqjTARQj1oVeOF78GgdX9/uJ9NkkM4rL/83mgmjB
         EB8cADc96yZsHWOVJTEF9URvz+udH6Dup5Fx0Lo6EkKgfoT8ki6AmO31AblFMps/At5L
         7v78q6k8m+G103UDacpnff5S/ejdDIVepA2mlO+099IKGzWpY1+EJSHjk2owpc/Yer5j
         ZjnRimGBKPZa8j8Nrw/7b2pgKR/Me6PNvuE4ccQNeSRoIMNRknbhI0B6T4ekV4zRpQCS
         FvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/e+LCZ73Q3kBJGbSA8LvNbG7OX30ZNqVmjoSsWRrS84=;
        b=V9j2vAfFFWaelGeEcE9/oj3ZAWiGwhuuK2fBeQOx+FRBr9yMhp+dZeSccErzUvo3Ks
         Ny+zo0Y/fK+3QqXOOC+jKKw4deV3KuWDbh8fSuVzyEP//eNPY3kNWFJ+4QC/pbdx2N3z
         R5jPXIjxM6mWzqhab0ngjfSztH0hecd3xXyqgcv/wSekazaSc2TPNodxoiPrbRLw4rhK
         nqL+y+V9evZb+ASkAycAfSEXm6f/pYJoP5KDzRa66wqF+QDqQ+JocUu8+i55RlZHkvUj
         7pRCutywd+9dZWlbIV3QFF2LcYIHIli07DfQ4bA0PIAfo7R8b4f1N351+h3Z986xcSt9
         LQHA==
X-Gm-Message-State: APjAAAVaRvls13ueWnBmCcgrhewuaDJp749IUQDc6CW40MdQ5BiYjDKy
        Uj4N9IIyBZvFedHoh6jkNQ3bwPVDDR+zoledys4=
X-Google-Smtp-Source: APXvYqwgkcChSHR3rTQPARxDxKQYSAYQ0+2FNmA28tGHu8PLsuJvdrT/XjC9n2VyldejxmR0PSepwRHi2nCQA36XOtQ=
X-Received: by 2002:a17:906:1906:: with SMTP id a6mr28354773eje.236.1556438568571;
 Sun, 28 Apr 2019 01:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia> <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
 <20190426193732.xk3aektc7fb4eg2h@salvia> <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
 <CABVi_ExHXzWui4g9YZUx2PdnXXfc-OPv_UY++0rvy3ymurki5w@mail.gmail.com>
 <20190427094323.enhkqeoeow4jgmlk@salvia> <CABVi_EwEc1x9dspiVHUKjoikvcCUTBMFbknFbR-yg+DaBcpAXw@mail.gmail.com>
 <CABVi_EyY+6igxjkryojqKLiTeM=XEAAYg3G0B0+25HePkBRu2A@mail.gmail.com>
In-Reply-To: <CABVi_EyY+6igxjkryojqKLiTeM=XEAAYg3G0B0+25HePkBRu2A@mail.gmail.com>
From:   Mojtaba <mespio@gmail.com>
Date:   Sun, 28 Apr 2019 12:32:37 +0430
Message-ID: <CABVi_EwkvJtbDq17zJeCVR2cEKVtLuQm5Ltnr35mUSZR56Psgw@mail.gmail.com>
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I found some great related info  in
https://www.netfilter.org/projects/libnetfilter_queue/index.html
Thanks again

On Sun, Apr 28, 2019 at 10:59 AM Mojtaba <mespio@gmail.com> wrote:
>
> Hello Pablo,
> Would you please let me know to make my own libnetfilter_queue
> application ? I need a reference to read more about it and start
> working on it?
> With Best regards.Mojtaba
>
> On Sat, Apr 27, 2019 at 4:00 PM Mojtaba <mespio@gmail.com> wrote:
> >
> > Thanks Pablo,
> > Actually i need this feature for redirect  RTP-media packet beetwen
> > two service. I want to optimize resource consumption by using this
> > feature.
> > All things works right, But i should find the right place to insert
> > this rule in my code, Otherwise if the service got the first packet
> > from end-point while i don't insert the rule,yet. I will face with
> > problem, becasue of the rule was inserted before.
> > Thanks with regards. Mojtaba
> >
> > On Sat, Apr 27, 2019 at 2:13 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Sat, Apr 27, 2019 at 01:31:40PM +0430, Mojtaba wrote:
> > > > Hello Pablo,
> > > > Just as better understanding, If i want to update using -U option, How
> > > > can i do that?
> > > > Suppose there is this rule in conntrack row:
> > > > udp      17 29 src=192.168.122.242 dst=192.168.122.103 sport=5070
> > > > dport=5005 [UNREPLIED] src=192.168.122.103 dst=192.168.122.242
> > > > sport=5005 dport
> > > > =5070 mark=0 use=1
> > > >
> > > > and i want to update it with this command:
> > > > conntrack -U -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> > > > --dport 5005 --dst-nat 192.168.122.1:1111 --src-nat
> > > > 192.168.122.103:2222 --timeout 30
> > > > Actually it was not updated and this issue was raised:
> > > > conntrack v1.4.2 (conntrack-tools): 0 flow entries have been updated.
> > >
> > > You cannot update an existing entry with NATs.
> > >
> > > You can probably make your own libnetfilter_queue application that
> > > allows you to create conntrack entries from packets. If you want to do
> > > custom NAT handling some certain traffic. You will only need to pass
> > > the first packet of the flow to userspace to set up the NAT mangling
> > > you need.
> > >
> > > I would need to learn more on your usecase for this.
> >
> >
> >
> > --
> > --Mojtaba Esfandiari.S
>
>
>
> --
> --Mojtaba Esfandiari.S



-- 
--Mojtaba Esfandiari.S
