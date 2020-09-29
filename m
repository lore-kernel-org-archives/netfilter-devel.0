Return-Path: <SRS0=rcIs=DG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85BAC4346E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 08:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B951207F7
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 08:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="iBIq4D0D";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="uh+QTL0I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgI2Iv4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 04:51:56 -0400
Received: from fallback25.m.smailru.net ([94.100.189.1]:50890 "EHLO
        fallback25.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725786AbgI2Ivz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 04:51:55 -0400
X-Greylist: delayed 2215 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 04:51:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:To:Message-ID:From:Date; bh=uhQdG2lbKmk/7pGegeK9v20iFl9hVLTfZrGeJSsrTO8=;
        b=iBIq4D0D6ZZmmMj13RJgMOhw/5MiN2xvUanjf7rejQ5EN1ZSYQuUfdRSVgCLWSfWoaVeL+oys2YGAc/O/xvQlBQSudjPyQdUP1cQtJ/eJfrpGRBAo13ertk9K/PczUXI5CUFUj9jLVd43yWvx+BimkfpDZMCIlWeYe+wkl0a+RI=;
Received: from [10.161.16.37] (port=53598 helo=smtp63.i.mail.ru)
        by fallback25.m.smailru.net with esmtp (envelope-from <yacudzer@mail.ru>)
        id 1kNAmk-0008MM-SQ
        for netfilter-devel@vger.kernel.org; Tue, 29 Sep 2020 11:14:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail3;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:To:Message-ID:From:Date:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=uhQdG2lbKmk/7pGegeK9v20iFl9hVLTfZrGeJSsrTO8=;
        b=uh+QTL0ImrlkFjhqO1dM+OpuimwyX2xDD9pFxWi/unjmgUYNdfjSR5kFZQzCFLppWvFNKNTyKcTYpnyDbUzWxVpUH6hOvDmsJt99rdKRUyWVLNziamjeswkFrZUTS1V8YGntWTgiszorLocSIZCUA2ixMKHUbAKU0E3VuwpEj9o=;
Received: by smtp63.i.mail.ru with esmtpa (envelope-from <yacudzer@mail.ru>)
        id 1kNAmi-0001Ge-UI
        for netfilter-devel@vger.kernel.org; Tue, 29 Sep 2020 11:14:53 +0300
Date:   Tue, 29 Sep 2020 11:14:51 +0300
From:   Evgeniy Yakubov <yacudzer@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1452886108.20200929111451@mail.ru>
To:     netfilter-devel@vger.kernel.org
Subject: nftables bug?? Maybe
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: quoted-printable
X-7564579A: 78E4E2B564C1792B
X-77F55803: 4F1203BC0FB41BD93B5088A1702AF0385BF4AE435618135B287325DACA1470C5182A05F53808504018E4B55E301C265AB8B7DA4FAD18BC0C6E63032B7A5D9D286451CAC46E028436
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7C2204D4F9A221771EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006370D3D68FCEFFDD9EA8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC8BEF872EBE2403574ECE0BBD950FC1A5AF5A38E1BE83BA0D389733CBF5DBD5E913377AFFFEAFD269A417C69337E82CC2CC7F00164DA146DAFE8445B8C89999725571747095F342E8C26CFBAC0749D213D2E47CDBA5A9658378DA827A17800CE70F3DDF2BBF19B93A9FA2833FD35BB23DF004C90652538430927162BF670285207B076A6E789B0E975F5C1EE8F4F765FC138205E60522AB1A3AA81AA40904B5D9CF19DD082D7633A0446828A5085A663B3AA81AA40904B5D98AA50765F7900637C983FD990E3CEF3BD81D268191BDAD3D18080C068C56568E156CCFE7AF13BCA413377AFFFEAFD26923F8577A6DFFEA7CB24F08513AFFAC7993EC92FD9297F6715571747095F342E857739F23D657EF2BD5E8D9A59859A8B6A1DCCEB63E2F10FB089D37D7C0E48F6C5571747095F342E857739F23D657EF2B6825BDBE14D8E702E4EE3A04994FF497E5BFE6E7EFDEDCD789D4C264860C145E
X-C8649E89: F1FE86ED439380E31B6F31C46073E97629C2C2A48035FDB622E6A19D2CFA2BE53A37F9C4D18B33B7
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj50aJSQv4UNYWy7Lc+iDLGw==
X-Mailru-Sender: 159DE679A9C6F65770158377D6DB31F483D69B97CDA7E26FB5927B02875C599EDA29946C770114310E40135273D2C498342CD0BA774DB6A98B1C6C7786703E36FD8D3128AD5BC2B40D4ABDE8C577C2ED
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B45E190BCCE31DF978DF84D2D534E748F075A575FEC77F6C3068F3CF0E9FE49B69D4FCE5AB3379DBFA4130029F436E18D7C56F0F95692DD21EBA727AC01E90FB2D
X-7FA49CB5: 0D63561A33F958A556551730CFD58F1A4B0118BF901E1B0F39A061D14816B66B8941B15DA834481FA18204E546F3947C9EB6D914E8CED3EDCC7F00164DA146DAFE8445B8C89999725571747095F342E8C26CFBAC0749D213D2E47CDBA5A9658378DA827A17800CE7328B01A8D746D8839FA2833FD35BB23DF004C90652538430927162BF670285207B076A6E789B0E975F5C1EE8F4F765FC79B25E177BEFA2CBD81D268191BDAD3DBD4B6F7A4D31EC0B7A15B7713DBEF166A7F4EDE966BC389F9E8FC8737B5C2249A1DCCEB63E2F10FB089D37D7C0E48F6CCF19DD082D7633A0E7DDDDC251EA7DABAAAE862A0553A39223F8577A6DFFEA7CB24F08513AFFAC7943847C11F186F3C5E7DDDDC251EA7DABCC89B49CDF41148FDCD13837A2BCF0203C9F3DD0FB1AF5EB4E70A05D1297E1BBCB5012B2E24CD356
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj50aJSQv4UNYgmaazNrOl/A==
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C90059D04A353E0DED3E6A6E9105B2E89A80077D3E0E9A007315242A3910910EDF928B3CF03E94849E0743DDE9B364B0DF289AD36756069A536122F84BEB09BBDFF42AE208404248635DF
X-Mras: Ok
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello, Netfilter-devel.


I tried to make autoload rules to nftables.

First, I created file with set of ipv4 addresses and apply it:

yacudzer@adm-ovpn-03:/etc/nftables$ cat OpenVPN_set_PRD-RMQ-star.nft
table ip filter {
    set OpenVPN_set_PRD-RMQ-star {
        type ipv4_addr
        elements =3D {
                    10.22.0.62,                   10.22.0.93,              =
     10.22.0.95
        }
    }
}
yacudzer@adm-ovpn-03:/etc/nftables$ sudo nft -f OpenVPN_set_PRD-RMQ-star.nft


Then, I created file with applying this set:
yacudzer@adm-ovpn-03:/etc/nftables$ cat ovpn-RabbitMQ.nft
add chain filter OpenVPN-RabbitMQ
flush chain filter OpenVPN-RabbitMQ

table ip filter {
    set OpenVPN_set_PRD-RMQ-star {
        type ipv4_addr
        elements =3D {
                    10.22.0.62,                   10.22.0.93,              =
     10.22.0.95
        }
    }
        chain OpenVPN-RabbitMQ {
                ip daddr @OpenVPN_set_PRD-RMQ-star accept
                return
        }
}

And when I tried to apply it, I see this error message:
yacudzer@adm-ovpn-03:/etc/nftables$ sudo nft -f ovpn-RabbitMQ.nft
ovpn-RabbitMQ.nft:6:26-50: Error: Set 'OpenVPN_set_PRD-RMQ-star' does not e=
xist
                ip daddr @OpenVPN_set_PRD-RMQ-star accept
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^

If I place set rule in same file - everything OK:

yacudzer@adm-ovpn-03:/etc/nftables$ cat ovpn-RabbitMQ.nft
add chain filter OpenVPN-RabbitMQ
flush chain filter OpenVPN-RabbitMQ

table ip filter {
    set OpenVPN_set_PRD-RMQ-star {
        type ipv4_addr
        elements =3D {
                    10.22.0.62,                   10.22.0.93,              =
     10.22.0.95
        }
    }
        chain OpenVPN-RabbitMQ {
                ip daddr @OpenVPN_set_PRD-RMQ-star accept
                return
        }
}
yacudzer@adm-ovpn-03:/etc/nftables$ sudo nft -f ovpn-RabbitMQ.nft


But error only when set and rule in different files.
I think that it a bug.

I tried versions 0.9.0 (in debian repo) and 0.9.6 (compiled manually).

--=20
=D1 =F3=E2=E0=E6=E5=ED=E8=E5=EC,
 Evgeniy                          mailto:yacudzer@mail.ru

