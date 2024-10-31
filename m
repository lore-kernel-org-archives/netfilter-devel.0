Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E618F5C
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 08:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730364398; cv=none; b=i5Ft+ZFiIVpZvB9N/HLUnpLtobBlXjYaRBbuxHiP1lts0OYIBBxEt+/SZ90PfGv7tjU1qW3oC9jps8I6yUy5hyXeFOZWcOidV+UNvtoRDkJdv+Kn7s4GKwCSZDHZ5rL+5VcUDJ+ezlUoCGpZbyO/sTHh9Mjx575h4iBDgUXKbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730364398; c=relaxed/simple;
	bh=hXqKpilfDvXaRHq1grISxJq0A6chusAj/dC1Y1d2tnY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=IPGIxEr/fzYPT6q6Uu0G0L8qfmqTPsaCSuEPhWyOkyhSjF/CMY1OVSD+HxBIov2t86KpY7x4Rf1649Dr+TSaYmdHPT4qeETykNBHxUEpkWLK9GoN9/g3OhH9VxkC3eczEu7nZTeLkrfj9cWmrmza9R+HxrMk0wA4iKh7SsK43Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 1E26D1003C3B61; Thu, 31 Oct 2024 09:46:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 1C6101100AD654
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 09:46:26 +0100 (CET)
Date: Thu, 31 Oct 2024 09:46:26 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Subject: cttimeout: link to own gitweb instance broken
Message-ID: <39onss6p-rso6-9qs1-6383-8669r37qpnqs@vanv.qr>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


>commit 49417b53c3c9f2217f95918ce44f670222bd69bd (HEAD -> master, origin/master, origin/HEAD)
>Author: Pablo Neira Ayuso <pablo@netfilter.org>
>Date:   Wed Sep 25 11:56:00 2024 +0200
>
>    update link to git repository
>@@ -162,7 +162,7 @@ struct nfct_timeout {
>  *
>  * \section Git Tree
>  * The current development version of libnetfilter_cttimeout can be accessed at
>- * https://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_cttimeout.git
>+ * https://git.netfilter.org/cgi-bin/libnetfilter_cttimeout

Something isn't quite working.

Opening https://git.netfilter.org/cgi-bin/libnetfilter_cttimeout with a browser
is showing "No repositories found".

On the other hand, the URL https://git.netfilter.org/libnetfilter_cttimeout/
that I had recorded in our distro-level packages works, but is missing the
1.0.1 git tag (if there ever was one?!)
