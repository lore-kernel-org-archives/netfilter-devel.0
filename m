Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1E6C11F65
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 02:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F7A61CEB
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 02:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhF2CFP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:05:15 -0400
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:33633
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230291AbhF2CFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 22:05:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKi7XK31J4T8YeL9UaFVQp2bXFpk+9G8Tx1tPQ9jgHCX6lyQ/Bc+3DXoS/GPBvkLvjOvtbzUxQm+rq4VNpe2tAn5B1gb7u2Lb3OSWiWMNIWgiR2DXFB0K75NiGfVn/7S274bgQ0mNcP5BubT2HNOqV+D4Idf+F1veY+oo+WCtbgdEC0V3azB/HX99YGYnDkmCuo1Qa4Rz3Q5ZBXQAw2Ee2g4WoSqrcm3s3Hqp0vM5GdksUW7gBS3pFMadOe+1W4Qdg56J1T4oEVKYC8IpoKs+achBDSdcg4EouMieHaxR+es0Rs0n6/A/2uWORFKHGjLh2JPD/OI3zZWqxx5Da4gbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxqEMlHI93HrYORHlhS1Gc8VwRsS4LvGj4Brh6RyWbg=;
 b=cRnrJg1T7anUoMeAOzwdgFM2YhJJ8ppdOgUviZlxcB3rdY13FUuUBJce1QbTbSO0bda9OcpEXz4sEcQBXzVAp5GRIti9MiI3vlyE3upwYGgti51QcwOZGBcx1v4uTP+sxV6TnKBd9xtmYe11jKDx3DGN+2vuHB3Mm1pLRUfUINkkEEwXXijMhQJaSj0oMOLMMHlae7aSHR30ntBAcN0zl6mO6ikUJwqubUHKgFcgapvJrqGgm2j5jJN3d//LJYZwQmPx4EwFyzsy/6EBBzw0oWxV3aKSsrvj2lNffANPj9nLOM3r5wsuHu2pnJ7A3E03q2zUZjcDtwIdhzl9Mn8VJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=alum.wpi.edu; dmarc=pass action=none header.from=alum.wpi.edu;
 dkim=pass header.d=alum.wpi.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.wpi.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxqEMlHI93HrYORHlhS1Gc8VwRsS4LvGj4Brh6RyWbg=;
 b=nXoKm2B9zMNNkKTcQYnj0E/lEuP7rvX6Zk75OmroyCBivfNlvBkjm9PODkH7yKqK2ywlyCo8b8AXU2DVE1kAkRPk5ZXDiVpeE2SE2vvrgYr7pE+hVaC9f0KN0sk74xZB2AkJ4F8OU4fiVInaNW9gd869Cqblpr6DuR+gq+JvMxA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=alum.wpi.edu;
Received: from CY4PR22MB0470.namprd22.prod.outlook.com (2603:10b6:903:be::20)
 by CY4PR22MB0101.namprd22.prod.outlook.com (2603:10b6:903:f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 02:02:46 +0000
Received: from CY4PR22MB0470.namprd22.prod.outlook.com
 ([fe80::6809:ed7d:cfd2:dc38]) by CY4PR22MB0470.namprd22.prod.outlook.com
 ([fe80::6809:ed7d:cfd2:dc38%11]) with mapi id 15.20.4264.026; Tue, 29 Jun
 2021 02:02:45 +0000
Date:   Mon, 28 Jun 2021 22:02:41 -0400
From:   "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Reload IPtables
Message-ID: <20210628220241.64f9af54@playground>
In-Reply-To: <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
References: <08f069e3-914f-204a-dfd6-a56271ec1e55.ref@att.net>
        <08f069e3-914f-204a-dfd6-a56271ec1e55@att.net>
        <4ac5ff0d-4c6f-c963-f2c5-29154e0df24b@hajes.org>
        <6430a511-9cb0-183d-ed25-553b5835fa6a@att.net>
        <877683bf-6ea4-ca61-ba41-5347877d3216@thelounge.net>
        <d2156e5b-2be9-c0cf-7f5b-aaf8b81769f8@att.net>
        <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
        <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
        <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
        <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
        <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
        <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
        <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
        <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.148.50.133]
X-ClientProxiedBy: BL1PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:208:256::19) To CY4PR22MB0470.namprd22.prod.outlook.com
 (2603:10b6:903:be::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from playground (73.148.50.133) by BL1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:208:256::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.14 via Frontend Transport; Tue, 29 Jun 2021 02:02:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0a3e4f2-26d9-43c2-a849-08d93aa1fcac
X-MS-TrafficTypeDiagnostic: CY4PR22MB0101:
X-Microsoft-Antispam-PRVS: <CY4PR22MB010197825F4DAAF22C157F6788029@CY4PR22MB0101.namprd22.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dq+yQPARsI22/mpDQJeRi2JxgvKmWnQE9hZ0x2QVrpHDgcipG5x99e38TQq5PyvkA24GQ92SpPg11l6rqnvi8W4bn02xKhzAjcCeVpjxTOtGhYILSZbj9T9peE0WGmPpJoIh4cIQrv8pFIZVyMpHQieMZIUnHwxvAHakEMAfs14cJ2IG+MdJHaxZq2en+oNYDMOfpv1W9ah9Bh9m3fycGWCiQIQ5uIUgnBjfvr53sBLFN4tlXPOnHuEvoc2k8cu2bJWkrfhkzMZCfB8COqmyy4AMKxeFVFasJDPySk3KrdjAoVpDE7RwB18bfbUBBenxpaDSmTVy/Y0XLyrUV9QWkeMYCIWM0qfU0wdS0T9e/B/Ig8Ic07dJnErc7T+Qdwq5C4Ab8IUqew1/yNTkVHzDZYIjqKEapTX2XFDzXo6Fi6zfqNKmCsdSUDFuiliBwV4IhKc9HUqKBucbEjna2+zPL3g8GOXUmXJKFkxCNvAYCln9v6bIU4M9w8GitULjZhdR0fOsvdUSZFjdfL5OW2rnWA2SFxrfR1rm2aJVlCkb8EWaqLxAFzjTd3YzB3f53OcdvgFpupiLKrxkwmO6miGu4gvgdy6AmRB7nKC5ffYjuoS9CjliSfgybt1MQIY1H9eIFuMkWFO70MVDyrd56yjJi23QBSLD3GW3zaPXNWeUNCVI71zjv8EohFPeL962PXzcNQ5vGmV6R2QNym4MZH+REQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR22MB0470.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(366004)(346002)(136003)(376002)(33716001)(38350700002)(6666004)(956004)(75432002)(38100700002)(786003)(316002)(1076003)(3480700007)(4744005)(86362001)(9576002)(9686003)(7116003)(450100002)(8676002)(26005)(83380400001)(5660300002)(55016002)(109986005)(4326008)(16526019)(186003)(66476007)(66556008)(478600001)(6496006)(66946007)(2906002)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Og0rI+VA4AYMT7fqq6aQBvhRmOHo3LtdUx70FUbpn2MBcXed6ZEJVkO4vV+X?=
 =?us-ascii?Q?D8mPGXjtRsYIVGSbKPjLQjLnjxblGpc1lgL2yP+NDJkVbgnmxUCHSb2w9MOq?=
 =?us-ascii?Q?uEXYBOqUXBSgiGg8xK0ZCCjkOmmxb+pHCV3zqpEpmQPR2Z2gUsyn9jKGT7B3?=
 =?us-ascii?Q?LLWKKCN88KquWnVlXTF3XUz9X2Jpv7PQussarc+uQy5p2L7tjkXwKesduhzb?=
 =?us-ascii?Q?Tqx/YlDT9rIKIdrSkPgAubFwFj1T5uzBH1vWmUuJJCilO8gE6PbjmImZKUI4?=
 =?us-ascii?Q?1AbiseneRDZZuGvdnJPV5a5KBgWOoKSORVivstdNn2AeTqxlZovhGtPQPDnn?=
 =?us-ascii?Q?2H/qqC1EKtVH935nftfSy0rffQ9ZDqUH4mY58MiYm/lFKOJrx9FTKWBGCr91?=
 =?us-ascii?Q?R1RqOUNVh29icA6tCdhGk56/Cz5D/dPTuy9YnlrWaZUKLRfDKgocjwgcKFxC?=
 =?us-ascii?Q?xrspfIuWM121gn6MXYD+2B4dVLhLbHnKS8fbZaoyxASFGAKTAXYQa/fP+O86?=
 =?us-ascii?Q?UaSC5Q2hAKu6w2byIDoNnot1qXmOzIBV/6Bt9uBOfFWSbA1gMlKBdjvi3CI6?=
 =?us-ascii?Q?0YkC7V+inkOXR9F9+vCrO9A3XTb0Ak3d8TmHM8F2YJy3ExCqKmVR6wCKOWFO?=
 =?us-ascii?Q?VU9dEKULs9c81SXUhpzln25oxum/awuXmjWRKej2lKFIjCdWWVR0UtzXvpAA?=
 =?us-ascii?Q?oP0ooFYyaEXiVKBBv0Slv9G9FRs8pgWbFBgIcqIlqSeVpLpeYMzWSmk8cIQh?=
 =?us-ascii?Q?4b+ekNBwOPycZhm5b1xZL0dpgaRoqz03snYFaOduJli6VVJMwP4y77hozf5f?=
 =?us-ascii?Q?sSfNPxdW7e8lZQThDDWo8PwvkusjTr+uKMG1E4D4ck9NkHXTaeyFQcnCeVRJ?=
 =?us-ascii?Q?a3YdHy25N5jSKdXiCoWYJ0DFs2LKXnjKb3Awr1IdJxAXTVPEjcmSFwu1OtVM?=
 =?us-ascii?Q?WIgNkKEo9hDxNs5C51tidEsfaiHfYoq01gioJBYVVr0k19T6HuU+3Rt6x+cs?=
 =?us-ascii?Q?MFUj71lmAvEu/k6SfHxCrSmGI019VHWMJSShFPKNtqLPETmh+67vi28kzRrz?=
 =?us-ascii?Q?wFhE4bCICYU7zDl+0epRqoH7XBuLHHgQgSiVxHu2dpNKIuDgioFKelYxguIh?=
 =?us-ascii?Q?xIqCKlEkStzZHol9GQ7v+9MVFho4P7oj/tsHTWorlcTf+LBQ73PqC2+qZERy?=
 =?us-ascii?Q?8TRTWoVBqEwYsgHOA5xmx8HSQUg6zV7gUL26Cu74lO0rR/xulr2LZ5Ap+rMp?=
 =?us-ascii?Q?Frp30uPdvnpTaRIb//ktyq7kQ0aaomXyJKAV35Vbeke6AwE/MTsrhV/iV0RG?=
 =?us-ascii?Q?g4DO+cjnaH4HHk2QIjCisKf8?=
X-OriginatorOrg: alum.wpi.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a3e4f2-26d9-43c2-a849-08d93aa1fcac
X-MS-Exchange-CrossTenant-AuthSource: CY4PR22MB0470.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 02:02:45.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46a737af-4f36-4dda-ae69-041afc96eaef
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J911p/v9JWOAcNIl2JrTu2cED6e7rbuli/KasjhUK0AdcFRfENhtviO2DOa/XotBmgEQjj2YCPM17DUly002eeU2VL9mX6iGWtYtFT5Bt7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR22MB0101
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 28 Jun 2021 10:43:10 +0100
Kerin Millar <kfm@plushkava.net> wrote:

> Now you benefit from atomicity (the rules will either be committed at once, in full, or not at all) and proper error handling (the exit status value of iptables-restore is meaningful and acted upon). Further, should you prefer to indent the body of the heredoc, you may write <<-EOF, though only leading tab characters will be stripped out.
> 

[minor digression]

Is iptables-restore truly atomic in *all* cases? Some years ago, I found through experimentation that some rules were 'lost' when restoring more than 25 000 rules. If I placed a COMMIT every 20 000 rules or so, then all rules would be properly loaded. I think COMMITs break atomicity. I tested with 100k to 1M rules. I was comparing the efficiency of iptables-restore with another tool that read from STDIN; the other tool was about 5% more efficient.
