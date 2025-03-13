Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93969261591
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741855755; cv=none; b=Htmh8SEUqEujqjfcvw4ovGM9zNw7HoIxjzRXUszP+0+fMUN85iTol5Af+NKROrl1TovYig6WPjP8rIFQLFc60lNARiuR3+DS2O+P4Y6rrbXMoLWfHopxONVNOA2+U3CWzSmv9rd8YM5agZ2KyAKx/eXea7THWEg1DDUvctX1zxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741855755; c=relaxed/simple;
	bh=RbnpEcHEXhUGo5qFmyKQ7jYqyjpSRjAsn7c/nlsQiBI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MMJhann/S1eNCSu/99aPCjUgcUKmDU/IcBVTDu6l87WubplR7wY2WXsn3pvNYmEK+SIBYhMlhTY9RQVIK2HE77y4GcA8FVu+6HHUqFGAt+GLDrOBtIW7a4qPZQlFMdF2G0OcbepwekYiekN9BtKYHMuwvoutzsfHynZSyCjBK58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tseFZ-0008Nq-16
	for netfilter-devel@vger.kernel.org; Thu, 13 Mar 2025 09:49:09 +0100
Date: Thu, 13 Mar 2025 09:49:09 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: [bug] nft asserts with invalid expr_range_value key
Message-ID: <20250313084909.GB31269@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

nft -f -<<EOF
table ip x {
       map y {
               type ipv4_addr : ipv4_addr
               elements = { 1.168.0.4 }
       }

        map y {
               type ipv4_addr : ipv4_addr
               flags interval
               elements = { 10.141.3.0/24 : 192.8.0.3 }
       }
}
EOF
BUG: invalid data expression type range_value

Q: Whats the intended behaviour here?

Should this be rejected (first y lacks interval flag)?
