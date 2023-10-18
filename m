Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E372DCDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 11:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjJRLyc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 07:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjJRLyb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 07:54:31 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1962F7;
        Wed, 18 Oct 2023 04:54:29 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D66713200A63;
        Wed, 18 Oct 2023 07:54:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 18 Oct 2023 07:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plushkava.net;
         h=cc:cc:content-transfer-encoding:content-type:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1697630068; x=1697716468; bh=1gGqnibbva9eW14coSmCGtj86
        v04dw3N2U7HGKRvwCg=; b=kAlLpF1FoRfr1dvl+XNacQGvNpGd6KiKGig7YGJPu
        KJNf4Lxm3L/6mq/gNrIffZ9KAFT38duKe2YXjdMe+j6RF/tHo2Gz87QRr3uH+ca6
        yPSF/zNsoNXt1Tzeh33RYj9Ibv3SYZhSXF6HKc0RrM6FUwDrz1ahvqOzmHi0F/9a
        727D5Qtz8BKkC7zHWsrIX7TUcjHybsEVr6zozDH2MLsalhsYAO2Jjq0zd2wwI8E7
        Fuwd/E7XBH69p6SMfnvm5Wi0rDBGB7FrwdbDzFTFdZ7tLNhw/6PMiNq7OPF0qW4Q
        VQAkBMjlXTL6dwebSX38UNAAT3d/gyFUmc7guqnF7LVsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1697630068; x=1697716468; bh=1gGqnibbva9eW14coSmCGtj86v04dw3N2U7
        HGKRvwCg=; b=ACZ63ga+1D16m3MQ0K1Egncs+YjwW2/AC5Lq75/cUPOtb6XzJ/K
        YcPiMeW/VrsVbb3s5+MswXq+llgpnAwu6nInfh4uxf+iyMg0itGKqXnCt81l5LEr
        Ystvjl4rYthvh60UZ3NEKWAlkg8YQ9tZgP/28+LEBLrj/skuen+GXAG011bQBU9H
        RpDq/4P5LnLz5Xk9o6ooMh0zpCVbR0FPtJgn01Y7dkO0v9Fu5FMBNt54NGcVgvqn
        YoNlMmIJi5NurDmqdWDHSip+2fH4v9lYbXa532zkhoSg7gvEC6ujy7O4PEIqlalS
        y0rOaGb82vsb0JGlt/uZ+/8fTkR/tSGKiYw==
X-ME-Sender: <xms:dMcvZVfmGlIfRoxPw0KwyCzYeGN9SGkEd8CQqC7DZn7PQ0Pvr1oNfw>
    <xme:dMcvZTNZkDIeLAFPrbLdkeJtFclbS80iS9OoyWgwY1KTa5QTgOrRDFzxE-Be0duir
    lChh2Qyk5DXefSD>
X-ME-Received: <xmr:dMcvZegk_qMBlwL7_F-QSy1g8sW1nBLKaQ_d54hAKUbUl62tuBPWAJG1qZEEO3iGUOXxD8ztx_RAxOCOP76q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrjeeggdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfgjfhfogggtgfesthejredtjfdtvdenucfhrhhomhepmfgvrhhi
    nhcuofhilhhlrghruceokhhfmhesphhluhhshhhkrghvrgdrnhgvtheqnecuggftrfgrth
    htvghrnhepiefhteethfegfeetgfehueegfeefheekudekfeffjeeguedtgeegjedtieeh
    hfevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkh
    hfmhesphhluhhshhhkrghvrgdrnhgvth
X-ME-Proxy: <xmx:dMcvZe-SIaOiMNWxr_M67VjBnlkKq35ydMGkhAYZS5WNv0mWMBZBSA>
    <xmx:dMcvZRsO5pGnV_igN8J6Dz-KA0w9zBlH6gtHqi6hVGMMnxEBDGC6vA>
    <xmx:dMcvZdHfarsExeCU1c-RqjFKjq1pqAfGHgYax3GqmclFzHdsPmHmqg>
    <xmx:dMcvZZIOp5cnCmwHvVR6pipbcuW7uLEHmdjl90JWcUCsvyLVkyiWQw>
Feedback-ID: i2431475f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Oct 2023 07:54:25 -0400 (EDT)
Date:   Wed, 18 Oct 2023 12:54:23 +0100
From:   Kerin Millar <kfm@plushkava.net>
To:     "U.Mutlu" <um@mutluit.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, imnozi@gmail.com,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
Message-Id: <20231018125423.a165a43e90e7f93994677244@plushkava.net>
In-Reply-To: <652FAB56.5060200@mutluit.com>
References: <652EC034.7090501@mutluit.com>
        <20231017213507.GD5770@breakpoint.cc>
        <652F02EC.2050807@mutluit.com>
        <20231017220539.GE5770@breakpoint.cc>
        <652F0C75.8010006@mutluit.com>
        <20231017200057.57cfce21@playground>
        <ZS+nJS/4dolCsIk8@calendula>
        <652FAB56.5060200@mutluit.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 18 Oct 2023 11:54:30 +0200
"U.Mutlu" <um@mutluit.com> wrote:

> Pablo Neira Ayuso wrote on 10/18/23 11:36:
> > On Tue, Oct 17, 2023 at 08:00:57PM -0400, imnozi@gmail.com wrote:
> >> On Wed, 18 Oct 2023 00:36:37 +0200
> >> "U.Mutlu" <um@mutluit.com> wrote:
> >>
> >>> ...
> >>> Actualy I need to do this monster:   :-)
> >>>
> >>> IP="1.2.3.4"
> >>> ! nft "get element inet mytable myset  { $IP }" > /dev/null 2>&1 && \
> >>> ! nft "get element inet mytable myset2 { $IP }" > /dev/null 2>&1 && \
> >>>     nft "add element inet mytable myset  { $IP }"
> >>
> >> Try using '||', akin to:
> >
> > Please, use 'nft create' for this, no need for an explicit test and
> > then add from command line.
> >
> > The idiom above is an antipattern, because it is not atomic, the
> > 'create' command provides a way to first test if the element exists
> > (if so it fails) then add it.
> 
> Pablo, unfortunately your solution with 'create' cannot be used
> in my above said special use-case of testing first in BOTH sets...
> 
> I just don't understand why the author cannot simply add a real 'test' 
> function to the nft tool...

One a feature has been added, it usually has to be maintained forever so it is to be expected that the use case has to be strongly justified. In my opinion, the principal shortcomings of "get element" are twofold.

Firstly, there is no way to distinguish between nft(8) failing because it did not find the specified element or for some other, wholly unrelated, reason. In both cases, the exit status is likely to be 1. That makes it a poor interface. One solution could be for nft to at least promise to exit >=2 in the case of syntax errors, syscall failures etc.

Secondly, the use of "get element" entails spewing a diagnostic message to STDERR in the case that the element isn't found. The user is thus presented with the unenviable choice of silencing STDERR. This is a bad thing because, in doing so, *all* errors and dignostics will be silenced.

Now, as concerns the matter of producing monstrosities, there is always the option to write the code in a more elegant fashion. One way would be to compose a function.

in_all_sets() {
	local ip=$1 set
	shift
	for set; do
		nft -t "get element $set { $ip }" >/dev/null 2>&1 || return
	done
}

if ! in_all_sets "$ip" "inet mytable myset" "inet mytable myset"; then
	nft "add element inet mytable myset { $ip }"
fi

Of course, this does not address the aformentioned shortcomings of the interface but the legibility and maintainability of the code is improved.

Another would be to apply the redirections to a compound command.

{
	# Neither of the following will be seen
	echo "stdout"
	echo "stderr" >&2
} >/dev/null 2>&1

Though Pablo already mentioned it, the overall approach amounts to a TOCTOU race. The prospect of being able to atomically check for the existence of an element in multiple sets is a curious one. I, too, would be interested in understanding the underlying use case.

-- 
Kerin Millar
