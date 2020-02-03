Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3361DC35247
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 17:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB9D62086A
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 17:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="KTX9RxEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgBCRtq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:49:46 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:32512 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgBCRtq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 12:49:46 -0500
Date:   Mon, 03 Feb 2020 17:49:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1580752184;
        bh=LZWyT4x9q5jdimOIVrKCiPt5lk5vbKi3arIOwD3MeGc=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=KTX9RxEIQt/MskYmhngV4/DSJQTx1EmRviY1dNPzpkUxMiIqJyScJ2VRVkeCGHwej
         MF+kRg9aDIvKKk0kJ71CHSRcT3Sa1hCOtpno8xA0T5l75R44W91hF4wmmmwsDfy7Xh
         ZVD5MDfliQkR7izMS/iTcdRsyNHxY0L/urMm8Hw4=
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   dyslexicatheist <dyslexicatheist@protonmail.com>
Reply-To: dyslexicatheist <dyslexicatheist@protonmail.com>
Subject: Re: invalid read in
Message-ID: <s7HX6aItJNJ0k3vJDOdNMEIR5DZxNsav0EwjPqFGroEYHSRmMrGoNy6SX_gHXvSatbsTt1yNihtxUXK_ARVqtWmAsDhmD5fudDnu4mA8Tro=@protonmail.com>
In-Reply-To: <20200203173003.GF20229@orbyte.nwl.cc>
References: <gwRjoIGUgI5MEgxSob7CBSUwPbYkxILRc4_ZrYWYNI7d1-T5Ej95p3XkEY_f9hLqHK5nVun7dk6RqObi0c_4482IJ6s6U33PyS6Hrm4z46E=@protonmail.com>
 <20200203163152.GY19873@orbyte.nwl.cc>
 <7BnNOPQw33ulxkwoWPovsrpwB_JPbS5nJhaTevbPCUkPRxObOpyrmqo3pFe_h82tov85DMfE1cYdX1xX3xhHNLbTef3XXmkqU26_ulUKpfY=@protonmail.com>
 <20200203173003.GF20229@orbyte.nwl.cc>
Feedback-ID: LnsYXauhtR_e9kgk2d-isThAhyxIsD2PcS0_jrp6ej-3I2WPS9tR2zudCE_YY9WCDyXkRWYo2nBz1g-cDBMDOQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday, February 3, 2020 5:30 PM, Phil Sutter <phil@nwl.cc> wrote:

> > thanks for your help Phil. I have just tried this but unfortunately it =
didn't change the outcome. Also tried other variations such as memset'ing b=
oth &u and the &params struct, but nada.
>
> Maybe you need to apply the same to __build_send_cfg_msg() as well?

thanks, I just tried this. the error persists. this is puzzling.

>
> Cheers, Phil


