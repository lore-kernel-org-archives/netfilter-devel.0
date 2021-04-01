Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB889C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 04:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A50BF60BD3
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 04:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhDAEI2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 00:08:28 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:60347 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229539AbhDAEIK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 00:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617250089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MCq0KLKBWYMcwMToDyfuGqB/e50pIvGXqIRJbmxeNXM=;
        b=kXsDFcDDpJHs5fBMxr7DdZPWkL16XQyKNXLQ1BeNPxhrIHaHtAHqu4mACmker4dLU2Jn6G
        W0+XGfEvQliWnq609xkiGMKYaTRmTGcmGNsir52+rh/4234+gzF7MCWA1iVcVLQS+aW7QB
        yI/YusavxFObkr4k1oy9ogoCIimjOzo=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2056.outbound.protection.outlook.com [104.47.8.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-tAIJ7apHNG6EDLdj0YYC9A-2; Thu, 01 Apr 2021 06:08:08 +0200
X-MC-Unique: tAIJ7apHNG6EDLdj0YYC9A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7Az4sHA32NH9V3d4HawiNAHgatyx5bC49zfLhQwdKtXf3OJJn3RiV16yi9tgnNVDIIPuXRponLJE2uFAgEuzMOhFFgy8xKvhAkc0dFSyt2hwYlaXMFzaZJVxSyLLp7kb2lM7u6nKmbRk3DJvo9641yLJ1tW6yf4nKGUxKq3d6PLzKPyGqBS24E/B/qJ3F2vGnxomMspW7H0Vo1M4lLFyTOzuQ0rM71F5M8ZDv0fjaNhvm/4pd5kSfkYDrsmJoxx+/h4BhRsEomV7ExaM1jz65eweTwLbfA2DfMLVuv0LrgCwKlGvJLP4sUUTGFHXAlUYyv38762gh83t9Hj8mf44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7Bbqprf65dJZqLIeut04HhFwPdBLUFRsAbx3xEmMWI=;
 b=jKH7MvabNu9BROmNKS+6oOwYHTNQAJAR5nKJWgzKLUBLYfxkv7gZ+TDrmj5IvFPH3TM+dFBga9LqVx1rMxnv6Dk1zYowxiEdMLgNuBD6JkhTw99XzHoM52humtnY7M0rKuTXFGk1XSCVmyX96zSQ+HvG4ZT5LXWbSnaRsK02svP+msJgfzqq0uRXtV1wRB4LLIMjkSaTHSB+GgJmVRl+sZ8i6rTCcDe4iXLTvC9qkgxnnRG0ZrnvcQgryZtKkzl3aX+wR3Ad/VZtTXkxwitFOLIRioYLwt6TEKB3bGotGNUqJB782IGR6mRd4Qq+CxGM7V+Hbutn9vi5Xsh5bKrusA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR0401MB2320.eurprd04.prod.outlook.com (2603:10a6:800:29::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 1 Apr
 2021 04:08:08 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb%7]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 04:08:08 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     netfilter-devel@vger.kernel.org
CC:     Firo Yang <firo.yang@suse.com>
Subject: [PATCH 1/2] ebtables: processing '--concurrent' beofore other arguments
Date:   Thu,  1 Apr 2021 12:07:40 +0800
Message-ID: <20210401040741.15672-2-firo.yang@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401040741.15672-1-firo.yang@suse.com>
References: <20210401040741.15672-1-firo.yang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.130.191.126]
X-ClientProxiedBy: HK2PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:202:2::29) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (36.130.191.126) by HK2PR0401CA0019.apcprd04.prod.outlook.com (2603:1096:202:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 04:08:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edfe7b82-3bac-4725-a0f2-08d8f4c3c1ae
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2320AFA79BB547BA9060ADAD887B9@VI1PR0401MB2320.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJdpYf72wIg/bNlkzsCAzj1c8mQKhCbRtkofQXaPIYRadabxhFF0pXTmd350RIStbEZi2yepAdqPXufGm1IswOatR4QVqT8Ncd3/UgoUq7Hj/OEOasa8Go3xauxGDhmRlCeDwEb8SsPK8f/jMpv2HUwXDUaA6aXodBJrq4VpGUafrHn9b723b00yL4RofDXTb40XG1xDxoVocFXA8eho1nuxhfEB70ecPRppLMYXldIcj7itZsNi20j5AxhptrU+x0PxfAZ9Bo4OUGzgqAVgYcKFhmQFjRy3jcIWV9zBGeUwODZqcGHqbRHu6w33YtbU4/YjaJPIhaFBP9GsG47/5gS4HYtiB18I3nuYo6wzwhwsZcCowJwCCybbaykz1Bfl10apbkX0hJHfs1p7P6jTQh364Nxy5OJOkileg9TB6PfwavlWYyA97px6CeMx1XDobO/Fv3g6G5LHR9/sBtWBUmA39O4HO5SCZm1vpWAzxSrM1TKXdCbNTaFuGMoYf3zDEk+XJnCI0qlkckwxnSo68764bdG91CcJYjONqhTLkWLFF9AoymFvNUVepp3UU48S4QMtyooJ5VIEhH7sqytXEBqHhqYUvnFyaii3KjlXfsgvbRU9Own739SCzaPk+biGrNKIyApzCF6z4y7t+4dKW1eje4vciromHqbThycZXoCdJ0+orbz7oB+LhB3yjQGL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(44832011)(16526019)(956004)(107886003)(66476007)(26005)(4326008)(2616005)(6916009)(5660300002)(6506007)(52116002)(38100700001)(186003)(8936002)(1076003)(66556008)(6512007)(86362001)(83380400001)(6486002)(66946007)(8676002)(478600001)(2906002)(6666004)(36756003)(69590400012)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+ZhvbGTu5QvWhgZzeMAnbr74HnyzMJasdMhGqm1l0NNOPNpcrtbbUS/yw+tv?=
 =?us-ascii?Q?9bTs95pZy1RF9bKT3jzvhwfFO7bU4xKrZ53+5i53L6q8/pu1eW9gdD3Z5C9g?=
 =?us-ascii?Q?ktvz3dLok9feHKPfMqnODWNqpZ9fFecET/amdxsytLe4bxpowxaSdm1IAbXe?=
 =?us-ascii?Q?aVvaz4Ezp4+m5XL3wwFAv3dr0QJjF57qIDGXTPU+BhEp8W5XIDVKpsgUSKbG?=
 =?us-ascii?Q?+d6fSU7/noLkXvlOg5RloKYKd0vfMEVDue3a24t5rcFwlDSpv+/Tm19gPC4L?=
 =?us-ascii?Q?EogN3nOSd77lYJAUA5Q5kS3V4ncmH/sWnB8MPvkCeur12qiQloO1IH23E9c3?=
 =?us-ascii?Q?FqPwSlmBpmajQyRJoDD/RAp7j+u1LJ+jkCYxRQrjvqtOe3EBtgr+bI6QGBbB?=
 =?us-ascii?Q?1fa7mx7VmksBP2axm5QnLMiI1LI1hTAZurBM82ukQg/y8IBqOKr7lG9QRqKn?=
 =?us-ascii?Q?1Xh+4tWkP21hNmVEnP+7/TpOMzr1sP6p1n5reb4qpACnzMxwan6g5PHhYnHf?=
 =?us-ascii?Q?TM3WaTbkndBu9wzXA0ar9+SeAVEMnuhABAa9CQ6zb3lvDX5NCmguR5vq/Iif?=
 =?us-ascii?Q?2OLJmCIhBl1b9BlDzU+J6gXDyy6CRzvOdPhpCB82kyn3VLzcfhcyN2OwaDfg?=
 =?us-ascii?Q?lQ+0+6GYleqU0vcx5C6uLEViQnp4ABu9BJ0ZddupkgfsVACsRrL+1LD0Izg+?=
 =?us-ascii?Q?b3mmRGwNrFW4y10YzLLM9PtaP2iRyTAd8RrzrO41zao/BhAgaDvN1YWP81aJ?=
 =?us-ascii?Q?PdyxAf+hOuxhUHVHNMdk+v6lJuTJfk8GFjxqfX6CNtB41asSaeLsi3C9WSPG?=
 =?us-ascii?Q?+lW19tHODUwwdWfWADJyx8vgzmdWbOZvzEIBkLGvwXX5/rwCJfJh//EeYMYe?=
 =?us-ascii?Q?1peDxdUlOXPYzVJw0tCEcHSgZitjem7vsGb1JwD3YqRKndLeyw9xmFhasPo/?=
 =?us-ascii?Q?mYSBoGyPlc/Sn9E61vz/eavtRWoaifHeK4UcCsIBs/0H3EA1GqtVuJ0i+eYA?=
 =?us-ascii?Q?meMk97gqt62eczsndP6tFGFtCsSZ5h+xfLcO8j15wm4yqWq4/k9rwg6aFCZg?=
 =?us-ascii?Q?wFtOxyMLwu+/cqUWGcyo8jvOiXJTZefvTlbujWZy8XYcMyFBCg/9AP2b3wPU?=
 =?us-ascii?Q?6vhR4Te8Ulu1kpeU14KlBE5ouHHOT9T8nG3K8mX5jro+pEighUgeY8CffvB7?=
 =?us-ascii?Q?lFeERZrjx2Hak8PKRLi5nGvJTCtqPs8lcvIDF6T+PuuGGfVnP22BR1VEgiZE?=
 =?us-ascii?Q?+7Dq4VAFzdLxPhuNKSiypLKIp3kDVMeNtUy+ErqZx4wKOsWGwlS6H/QBocJE?=
 =?us-ascii?Q?DTZ/Vpq7lHoX7wh9gAMP2A+f?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edfe7b82-3bac-4725-a0f2-08d8f4c3c1ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 04:08:08.0091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+Nt55rKxRxaXoXJbzp0k/XFnCsMaARL8XujD4nFREBsVtY9ArR92v8iTj+Vm+o4rbsa/oYAJxtqLM/pSqwi3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2320
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Our customer reported a following issue:
If '--concurrent' was passed to ebtables command behind other arguments,
'--concurrent' will not take effect sometimes; for a simple example,
ebtables -L --concurrent. This is becuase the handling of '--concurrent'
is implemented in a passing-order-dependent way.

So we can fix this problem by processing it before other arguments.

Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 ebtables.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/ebtables.c b/ebtables.c
index f7dfccf..98f655b 100644
--- a/ebtables.c
+++ b/ebtables.c
@@ -98,6 +98,12 @@ static struct option ebt_original_options[] =3D
=20
 static struct option *ebt_options =3D ebt_original_options;
=20
+static struct option ebt_global_options[] =3D
+{
+        { "concurrent"     , no_argument      , 0, 13  },
+        { 0 }
+};
+
 /* Holds all the data */
 static struct ebt_u_replace *replace;
=20
@@ -580,6 +586,17 @@ int do_command(int argc, char *argv[], int exec_style,
 	 * '-t'  ,'-M' and --atomic (if specified) have to come
 	 * before '-A' and the like */
=20
+	while ((c =3D getopt_long(argc, argv, "", ebt_global_options, NULL)) !=3D=
 -1) {
+		switch (c) {
+		case 13 : /* concurrent */
+                        use_lockfd =3D 1;
+                        break;
+                default :
+                        continue;
+                }
+        }
+
+        optind =3D 1;
 	/* Getopt saves the day */
 	while ((c =3D getopt_long(argc, argv,
 	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", ebt_options, NULL))=
 !=3D -1) {
@@ -1040,9 +1057,8 @@ big_iface_length:
 			replace->filename =3D (char *)malloc(strlen(optarg) + 1);
 			strcpy(replace->filename, optarg);
 			break;
-		case 13 : /* concurrent */
-			use_lockfd =3D 1;
-			break;
+		case 13 :
+			continue;
 		case 1 :
 			if (!strcmp(optarg, "!"))
 				ebt_check_inverse2(optarg);
--=20
2.30.2

