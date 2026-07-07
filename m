Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1025441A798
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430791; cv=none; b=Aq8F9jMuY0mUkAJV39yxKqxRfP5M9aKhkC/xkT5bmT/8kwTjjyjnCVGKi+UEomeyF33pTFbD4ysCnTxslHcGEhR3Izyfb7ybvnmsxmQ8P8rWhIK+qYOnuESyVe8pycpGgYR0kJiqllsGmUZ8POJEQmi2xLEp13ebMaNA9Q7RLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430791; c=relaxed/simple;
	bh=ikK4j326EaO8DJc+zVUg7ZACK7WWLYMQwpf5+7xPfeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAVGfkceaVfUo+2mZtw5zCq1kunCBMOPjPZSJ4ZqDWYUaG5fdDStV+b9Qa1iXqAU4WHDUR/smm6Y5Ihz30w/bBe5682ZYaGnuQt1OC+LX8TriQpOK5XHiq2dtXt5IZfRo+kMQB/JWh6LSuygtLeTt9GBbC3LZQYhaXqN0RP4SJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LjLGn/0X; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LjLGn/0X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ku+cc8uwCqqUn06d2CTt4ocauHCiJHulGys+NbUcWHY=; b=LjLGn/0X4Lxwk0bQH/gKva6W61
	B9MJGdWzDWzMxntD8KmjchqLrJ9plugBYHKYNBr4jOP1VyPC+yDhvbeWMKTFuGm+InOcMXmrzJtjt
	OdHBBuHAhIP6Q8A69W2fskCTvvFZX3Lscy2A3c0ea2R/GBuYrhetyRGLhv2BuAMEX0s6shkqhqdW1
	N7Uf8HKhDIlCbIc0nHqDgRimEC/GWRZDLT3aGqLXHrsbCNv4Sv+o6Z7pCobRubRc+/0zLo+2q+SrP
	RzSG51ClPtpMi61OPLJiRNnZWSCUlOcm7261090awlvjTPP9fe+cf5ylxBPbff+3cFCGnfL5H4TOb
	VbyorWDA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wh5oa-000000002x3-3kzI;
	Tue, 07 Jul 2026 15:26:21 +0200
Date: Tue, 7 Jul 2026 15:26:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: expand get command test with open
 intervals
Message-ID: <akz-fH24aKQbjaHm@orbyte.nwl.cc>
References: <20260702123634.349861-1-pablo@netfilter.org>
 <20260702123634.349861-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702123634.349861-2-pablo@netfilter.org>

Hi Pablo,
On Thu, Jul 02, 2026 at 02:36:34PM +0200, Pablo Neira Ayuso wrote:
> Extend the existing test to cover get commands with open internals.

This test fails on a Big Endian testing machine running Fedora Rawhide
running 7.2.0-0.rc2.21.fc45. Does this perhaps test a recent kernel fix
or something?

Here's the test output for reference:

| W: [FAILED]     1/1 testcases/sets/0034get_element_0
| Command: testcases/sets/0034get_element_0 
| Error: Could not process rule: No such file or directory
| get element ip t s { 11 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t s { 15-18 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: Too many open files
| get element ip t s { 60000-65534 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| ERROR: asked for '60000-65534' in set s, expecting '60000-65535' but got
| ''
| Error: Could not process rule: Too many open files
| get element ip t s { 60001-65534 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| ERROR: asked for '60001-65534' in set s, expecting '60000-65535' but got
| ''
| Error: Could not process rule: Too many open files
| get element ip t s { 22-24, 60000-65534 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| ERROR: asked for '22-24, 60000-65534' in set s, expecting '20-30,
| 60000-65535' but got ''
| Error: Could not process rule: Too many open files
| get element ip t s { 22-24, 60001-65534 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| ERROR: asked for '22-24, 60001-65534' in set s, expecting '20-30,
| 60000-65535' but got ''
| Error: Could not process rule: Too many open files
| get element ip t s { 60001-65534, 10 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| ERROR: asked for '60001-65534, 10' in set s, expecting '60000-65535, 10'
| but got ''
| Error: Could not process rule: No such file or directory
| get element ip t s { 10-40 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t s { 10-20 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t s { 10-25 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t s { 25-55 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t ips { 10.0.0.2 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t cs { 10.0.0.1 . 23 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Error: Could not process rule: No such file or directory
| get element ip t cs { 10.0.0.2 . 22 }
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cheers, Phil
