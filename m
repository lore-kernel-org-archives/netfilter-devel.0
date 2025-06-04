Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0AB2153EA
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 10:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032965; cv=none; b=qRmHdRGt7LlTsSy9YJaDofEHxOtZdbXtKYICQoI7hYF9lD76ntWqUQXOySDEjKk8g9N8nhgOIb53YVuXSTjslHw/YunvoLIG4rJlXa9cRegJegV7aFUHS23eDzE9NhWU6txKuc8Oepn7YwQ0/8yALlvWhb0XQ5r7clfH5Juhq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032965; c=relaxed/simple;
	bh=buKalx/pw6nZVkJX3A0i63nPaTwKslPj0myCujfnATU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=pP8sBnH1NvubGvUSPoSFwm/03LlB6Iqj3EgdZKiKD7Xz9YBTWHenCsExSpdYNscK9svmDcEETfQiZ4T7Rj/7Uo/8LvBh57aTvW+luAV3sIFANlLACizKNTg8LFSu9zBjGZ3NNd+kvtub1bSJlwX3C9PZkMV1jTdGpM4LSfGHGAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li; spf=pass smtp.mailfrom=cock.li; dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b=Fqd7t4Be; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cock.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b="Fqd7t4Be"
Date: Wed, 4 Jun 2025 10:29:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
	t=1749032961; bh=buKalx/pw6nZVkJX3A0i63nPaTwKslPj0myCujfnATU=;
	h=Date:From:To:Subject:From;
	b=Fqd7t4BeaBaePBwmHNXbPb7Ybt9aKniEV16Sr3gtHOkmbOiP4DHVt1tWSMoQjGdvz
	 /RbMIt75URBja5NA5IqROyZRLupRTWxW4rTDVWVZLxz8yV+qvE0axxBJiQYpAndVNR
	 /ltgOJQvfsFSU3BbzSXSU9kEDEAdh0UxsHcuRoflkVQt1aNFOQ/1o+cmIqE3VMuUQz
	 Xz38RWz8gkAf2x06bWFZZpfKTtGcRq+DaQn+ReyhD5XDNklYER3rJ6orVSNb9UWnLx
	 a2ooMRhg7WRLLOw3FXgfs3T3urqkBPc4so/km8M9GtsEHBoqfmK4eAKG51mo6Y5aQw
	 8aaUGe8JrNZew==
From: Folsk Pratima <folsk0pratima@cock.li>
To: <netfilter-devel@vger.kernel.org>
Subject: Document anonymous chain creation
Message-ID: <20250604102915.4691ca8e@folsk0pratima.cock.li>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Access to the wiki is restricted, so I write here. On this page
https://wiki.nftables.org/wiki-nftables/index.php/Jumping_to_chain
and also in the nft(8), document the possibility of creating anonymous
chains when using `jump` and `goto` statements. The most basic example
is this

table inet doc {
    chain inbound {
        type filter hook input priority filter; policy accept
        counter jump {
            counter accept
        }
        counter goto {
            counter accept
        }
    }
}

The commit which implements the functionality is

c330152b7f7779f15dba3e0862bf5616e7cb3eab
