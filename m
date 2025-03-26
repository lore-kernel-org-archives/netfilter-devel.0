Received: from mail.mailboxbox.com (mail.mailboxbox.com [54.38.240.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621073D6A
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.38.240.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742979934; cv=none; b=OgIEKnJe4UbfdlI0gfrrPayDSjkHeCvygDegT1O6voY4gZvGlZxG0syQ+OvO9RQ+dpY9XNuM7+O3IlL9dKPBqBM/Dfp27FnZb1q7MXokVANGa20B6hBs7EqG9E3gc0gjO8USApmvdtrdNpxKgp+PCwn8otLugiBkgrEh4Oyw5ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742979934; c=relaxed/simple;
	bh=6WKeX/ZsR+b4S3bOzFU5axg/45eAcfxxPwPBQZT0FDs=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=lhRDdPp5ClGPmG82wAFUViI2Ub0dJQZK2GpXFIyT7S5Eb9XdZTT0ZNpnIDiTdppxc+mOSBgt7UJLn+f5mvgvPBEE5hl7vcb/KKEIxs4Nce/UJbiAzt4RXdWAg59fHYBFEqz/1HHQEt7jallEDsLo44WoDs2OJX0FdFs0HcVNc30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=connectedserver.com; spf=pass smtp.mailfrom=connectedserver.com; arc=none smtp.client-ip=54.38.240.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=connectedserver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connectedserver.com
Received: from mail.mailboxbox.com (localhost [127.0.0.1])
	by mail.mailboxbox.com (Postfix) with ESMTP id A6F1520E2
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 09:55:40 +0100 (CET)
X-Virus-Scanned: amavisd-new at mail.mailboxbox.com
X-Spam-Flag: NO
X-Spam-Score: -0.2
X-Spam-Level:
Received: from mail.mailboxbox.com ([127.0.0.1])
 by mail.mailboxbox.com (mail.mailboxbox.com [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id awcSAD-v5gCx for <netfilter-devel@vger.kernel.org>;
 Wed, 26 Mar 2025 09:55:39 +0100 (CET)
Received: from smtpclient.apple (unknown [188.90.125.33])
	by mail.mailboxbox.com (Postfix) with ESMTPSA id 56217765
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 09:55:39 +0100 (CET)
From: Rob Bloemers <rob@connectedserver.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: IPSET create exists issue
Message-Id: <184E283D-2392-476C-B23A-9939FE71CA34@connectedserver.com>
Date: Wed, 26 Mar 2025 09:55:28 +0100
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3826.400.131.1.6)

Hi Netfilter,

Hope this is the correct list to email, else I=E2=80=99m eager to hear =
which route to take.

Using netfilter-persistent package on ubuntu an iptables restart gives =
error when reloading iptables and a ipset already exists. Afaics -exist =
ought to work, but it still returns error code 1 and systemctl perceives =
this as an error.

/usr/share/netfilter-persistent/plugins.d/10-ipset start

Which runs: ipset restore -exist < /etc/iptables/ipset=20
Still returns: ipset v7.15: Error in line 1: Set cannot be created: set =
with the same name already exists

ipset restore -exist < /etc/iptables/ipsets                              =
                               =20
ipset v7.15: Error in line 1: Set cannot be created: set with the same =
name already exists

ipset create -exist vxs hash:ip family inet hashsize 1024 maxelem 65536 =
bucketsize 12 initval 0x9bb42fcc
ipset v7.15: Set cannot be created: set with the same name already =
exists

Also when directly using ipset create / restore I get an error where I =
expected it to be quiet because of the -exist.


Looking forward to your reply,
Respectfully=20
Rob Bloemers=
