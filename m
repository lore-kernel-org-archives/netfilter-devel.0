Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E71458139
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/2] memleak fixes for tests/shell/testcases/bogons/nft-f/
Date: Thu, 11 Jan 2024 22:55:18 +0100
Message-Id: <20240111215520.1415-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi!

I found these when running:

 ls * | while read line; do sudo nft -f $line; done

from the tests/shell/testcases/bogons/nft-f/, for some reason the bogons
test does not bail out when ASAN reports an issue, while it reports
[FAILED] in other existing tests on memleaks.

Pablo Neira Ayuso (2):
  evaluate: release key expression in error path of implicit map with unknown datatype
  evaluate: release mpz type in expr_evaluate_list() error path

 src/evaluate.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

-- 
2.30.2

