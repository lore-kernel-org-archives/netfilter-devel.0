Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609C6ECAAD8
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Sep 2022 14:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiITOSW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 10:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiITORp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 10:17:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2394B0E8
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 07:15:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id y17so6518958ejo.6
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 07:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date;
        bh=UVllaaJfY54VfwdjI1SlJIXQ3RK0FZc9WKdlFSTwdpg=;
        b=FiVBqfOStwfz8aFMOJozRLLfzdKOZZijlxLFMKbjXvjYUS7a49vggx7OmTFrixlRr1
         eJKKh5s1mn0vvgZDKr+8exrsc7/0qQJL0knQm9V+d1eJEooI4QXntbOOVESDr1IMonD4
         wVMElzQQiM1Y//Mel/acfpZQvPALAAmULZNrAZHAgS9RX8Ers86Qbu4Tn30MBghy1ke8
         mOdMkhTAKj+J7/RZFL/ezzwNBBquEDArutbY69M14eG+54Mf4Dph+2GMuLGsMe7hSlji
         cuGV109a0tTDSQJn4jI/ut/4NZrnZhkW9q1yHjpTH3C++DNgCQ9SlZrLAIhKp5ZxhV1s
         zlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=UVllaaJfY54VfwdjI1SlJIXQ3RK0FZc9WKdlFSTwdpg=;
        b=QlPTvVAkndRfffqaLWjcxRlRaugvhFWZSH7inqwzjF8tcD0e654I0WzoG7a5mq/fQG
         uxd4fL6mfie21/RxxQm5Kenm3kjYP4aQ+nndtsv4v6SDBn59RzWk3pBtVPwUR3L3vBoX
         x2lJi5AKKfnnmckUlr882y7j53EM57jlsrlSSFJuZPC00+sEGjClWqmVO3pqti4Bl92q
         u3k48BzSweqz6OYfXzLfSfctn+mEDo5IWh0t/lysXXBnbR5JprWFBQSUGFDHw3bWXYOL
         WW5acsKGjCNY9Hv1iGUg7eahj0WsaTnbQBhsEsmFRCCQzdQSfm+SwpO/mNs4RRo808IC
         M3Bw==
X-Gm-Message-State: ACrzQf3ECuBxN8Vpc/X3VoHPX1LanV2sUr4RvPjtRBlmAuV34hmXkIyS
        E9O53sMUJaKFlxt0ncjlMVQ=
X-Google-Smtp-Source: AMsMyM7pWmCzan6UEC82JSlWKNl9aMukoJeyhuRQSJLhAr+1K8/MlPuJwlhz+XTJtAnoEL5gPh0y9A==
X-Received: by 2002:a17:907:6096:b0:780:c085:21b4 with SMTP id ht22-20020a170907609600b00780c08521b4mr13730256ejc.293.1663683303112;
        Tue, 20 Sep 2022 07:15:03 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id mh19-20020a170906eb9300b0073cd7cc2c81sm879314ejb.181.2022.09.20.07.15.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2022 07:15:02 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Question for table netdev set list
Message-Id: <08BAFEF0-E82D-468C-A855-F5CB1A81ED8F@gmail.com>
Date:   Tue, 20 Sep 2022 17:15:01 +0300
To:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo and Florian


I have one question=20
is it possible to set list in netdev hook


Like this :=20

table netdev test {
	set test_list {
		typeof iifname
		flags dynamic
		elements =3D { eth0, eth1 }
	}

	chain INGRESS {
		type filter hook ingress devices =3D { @test_list } =
priority -450; policy accept;
	}

	chain EGRESS {
		type filter hook egress devices =3D { @test_list  } =
priority -450; policy accept;
	}
}
table inet filter {
	set test_list {
		typeof iifname
		flags dynamic
		elements =3D {  eth0, eth1 }
	}
=09
	flowtable fastpath {
		hook ingress priority filter
		devices =3D { @test_list }
	}
}



Idea is to set interface in list not to create many chains for every =
interface=20

now i receive:=20

Error: syntax error, unexpected @, expecting string or quoted string or =
'$'
type filter hook ingress devices =3D { @device_list }  priority -450; =
policy accept;



m.=
