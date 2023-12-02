Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Hpf+MFm6"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0F3D50
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Dec 2023 01:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OTAeDodODlg7KObWjH0PEY8JpxPOXKuM14JOzRhYPek=; b=Hpf+MFm6wQ5H9vCnmFMHQu7elg
	dO1LJLyKcQPfxa9/hGhdTUBg5DGWJRZ262C5tEdMhrUsUcX3fUfEV+LKllSI4V8OHZ8P/6BT5rsoP
	DJejZOF2AlLfTHAmdbzuGGWslIDX5ssw4Aq8YzUZWuIIQV0ZzwllpcLrf7bzPNpXRfV1/0FgpsOmw
	snzwp+qA+yf+yrFww67Eubk/BHzvWFoJBqoo/ec4KwavlK7hNdAZlG55+qXvifFQhVPnn1eYRrpGt
	M08bsV41Cwb+NSvYgnPDO4VQNRsnW5e99Y+9rBIvEc7izukQiQuEQCUJDznT8l7IyAgawqOk7D6cM
	tJTXgXcQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r9Mir-0000Oj-37; Sat, 02 Dec 2023 10:55:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 2/2] main: Refer to nft_options in nft_options_check()
Date: Sat,  2 Dec 2023 11:10:34 +0100
Message-ID: <20231202101034.31571-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231202101034.31571-1-phil@nwl.cc>
References: <20231202101034.31571-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consult the array when determining whether a given option is followed by
an argument or not instead of hard-coding those that do. The array holds
both short and long option name, so one extra pitfall removed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/src/main.c b/src/main.c
index c3c7fe23baa37..d3491cda7f8db 100644
--- a/src/main.c
+++ b/src/main.c
@@ -325,6 +325,7 @@ static bool nft_options_check(int argc, char * const argv[])
 {
 	bool skip = false, nonoption = false;
 	int pos = 0, i;
+	size_t j;
 
 	for (i = 1; i < argc; i++) {
 		pos += strlen(argv[i - 1]) + 1;
@@ -341,16 +342,14 @@ static bool nft_options_check(int argc, char * const argv[])
 			nft_options_error(argc, argv, pos);
 			return false;
 		}
-		if (argv[i][1] == 'd' ||
-		    argv[i][1] == 'I' ||
-		    argv[i][1] == 'f' ||
-		    argv[i][1] == 'D' ||
-		    !strcmp(argv[i], "--debug") ||
-		    !strcmp(argv[i], "--includepath") ||
-		    !strcmp(argv[i], "--define") ||
-		    !strcmp(argv[i], "--file")) {
-			skip = true;
-			continue;
+		for (j = 0; j < NR_NFT_OPTIONS; j++) {
+			if (nft_options[j].arg &&
+			    (argv[i][1] == (char)nft_options[j].val ||
+			     (argv[i][1] == '-' &&
+			      !strcmp(argv[i] + 2, nft_options[j].name)))) {
+				skip = true;
+				break;
+			}
 		}
 	}
 
-- 
2.41.0

