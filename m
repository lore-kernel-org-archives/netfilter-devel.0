Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VsgHrt9r"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17813A8
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YIs1l6yfHG3MEAZIo2PzCeSIfZE81qB9rWHN2JUQ3Wc=; b=VsgHrt9rXdLAnYcZfD/eOswURo
	0k2hCdkutQOz43DhKKjnqKAO0wftHb6BoRrO6cMRB4pD5o1pIXI0vApGcwsxK1sLjzvyespaDULmg
	dlC8tbn4Y4HxVigHnUAqbmS8XyCHJbs0YkBLj3kwtiGkkvqBlQccDjNDsE8pZMK6UEUf4N57Rgb6O
	y2Qh4Yr9ZJoZaJGZfJ6U87/VjTvljHGnT+tBa6WRsFDIrZhe18HvdrtbhMwPLaKYXuQ+AUT3P5UFW
	J1tfBpM0bJ6L9uuJVnyKvyRKHVvyquxGRByAhal4vN51HfXWw/1xWEkMh//sVCiWPQQMXqxwzgDS9
	VzTrLeOg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPm-0001jh-G8
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/13] xshared: do_parse: Skip option checking for CMD_DELETE_NUM
Date: Wed, 29 Nov 2023 14:28:15 +0100
Message-ID: <20231129132827.18166-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This command will delete a rule by its number, not rule spec. No -i/-o
options are expected on commandline.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index dca744773d773..53e6720169950 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1837,7 +1837,6 @@ void do_parse(int argc, char *argv[],
 
 	if (p->command == CMD_APPEND ||
 	    p->command == CMD_DELETE ||
-	    p->command == CMD_DELETE_NUM ||
 	    p->command == CMD_CHECK ||
 	    p->command == CMD_INSERT ||
 	    p->command == CMD_REPLACE) {
-- 
2.41.0

