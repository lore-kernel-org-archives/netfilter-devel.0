Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B431849C;
	Wed,  4 Feb 2026 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166828; cv=none; b=HLMknWS3yr0FoD1rbEnPYSU+JxUGhgi7tLTq03qIT1ikHBCQDDlF5aSxdxsUr36YOQKcEF8rvNJuKlE1JUfqShw/IQ5mKvgdf5IRpPuYcDlE22nQoWTTP2FZOg1X50XU+rgv03m/AljAfZlnd4jPoJrTx42mYyQ5NIFOTIVVjZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166828; c=relaxed/simple;
	bh=Ft80vlbxKey3m4R0LeLvi4vUfPPD/rA+uhsoveCXxoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=elKIPS5uPYqi9Rw2vCOmbOXwg1Qpoho69BymPTDHggEbJDyNvYHvNoPMBgO3olXzWUYuK7gb7Tq7tpt+4NLybvuRgb9n/2epsIRmyYDSHopk7Vlt89JV9u/AGa5FVBS1BOi/7/Np5gQkO9viqySTywtg82tldKsmVGAix1QwODA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FCFVnOmg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FCFVnOmg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 38196606BB;
	Wed,  4 Feb 2026 02:00:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770166824;
	bh=ZcJfjmVWAV7buNPQmv2sFIMWEBJ4LD+fQux7/PDzLUE=;
	h=Date:From:To:Cc:Subject:From;
	b=FCFVnOmg68vxDhqdfVl3qdwoYnFyTAvmaZFXZhnOiDLOGRZuF2gxmF6ihWweBdl8s
	 yUDtJO6DLpmputME3EhpLFnnIYOOLwOIeBZSqFjR5uGAP2CL7HUj21nNTnEpTtT/Xr
	 b42mAP6LyC9xbHvtbf4qxqaT4xWwGyDutFJ5u8OkT1KmSCb58HUdE53GJ8J4S1/k0w
	 L4/5SMk4zzS+r9qgej0Dg0Xm8gOeq7y8MKfgBwGewb9zr8mhMV/HJ1gMz7UtNSJc7j
	 +Bw6ODb6prR+M1qcMJE7HZfh17iIBe+2nfGLz7U+V4Sz8Wv9GthDddx64SEisgZTBZ
	 SQSn3tF1IGClw==
Date: Wed, 4 Feb 2026 02:00:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
Subject: [ANNOUNCE] conntrack-tools 1.4.9 release
Message-ID: <aYKaJFugoa7l5n44@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nXqxhrFKglGDWqSA"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--nXqxhrFKglGDWqSA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        conntrack-tools 1.4.9

This release contains bugfixes, for the conntrack cli:

- skip ENOSPC on updates when ct label is not available
- don't print [USERSPACE] information in case of XML output
- fix parsing of tuple-port-src and tuple-port-dst
- improve --secmark,--id,--zone parser
- improve --mark parser
- fix for ENOENT in delete to align behaviour with updates
- fix compiler warnings with -Wcalloc-transposed-args
- prefer kernel-provided event timestamp via CTA_TIMESTAMP_EVENT
  if it is available
- introduce --labelmap option to specify connlabel.conf path
- Extend error message for EBUSY when registering userspace helper

and the conntrackd daemon:

- don't add expectation table entry for RPC portmap port
- fix signal handler race-condition
- restrict multicast reception, otherwise multicast sync messages
  can be received from any interface if your firewall policy does
  not restrict the interface used for sending and receiving them.
- remove double close() in multicast resulting in EBADFD

You can download the new release from:

https://netfilter.org/projects/conntrack-tools/downloads.html#conntrack-tools-1.4.9

To build the code, updated libnetfilter_conntrack 1.1.1 is required:

https://netfilter.org/projects/libnetfilter_conntrack/downloads.html#libnetfilter_conntrack-1.1.1

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--nXqxhrFKglGDWqSA
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="changes-conntrack-tools-1.4.9.txt"
Content-Transfer-Encoding: 8bit

Ahelenia Ziemiańska (1):
      conntrack: -L doesn't take a value, so don't discard one (same for -IUDGEFA)

Christoph Heiss (2):
      conntrack: move label parsing to after argument parsing
      conntrack: introduce --labelmap option to specify connlabel.conf path

Donald Yandt (2):
      conntrackd: prevent memory loss if reallocation fails
      conntrackd: exit with failure status

Florian Westphal (2):
      conntrack: prefer kernel-provided event timestamp if it is available
      conntrack: --id argument is mandatory

Ignacy Gawędzki (1):
      conntrack: don't print [USERSPACE] information in case of XML output

Markus Breitenberger (1):
      conntrackd: Fix signal handler race-condition

Pablo Neira Ayuso (8):
      conntrack: ct label update requires proper ruleset
      tests: conntrack: missing space before option
      conntrack: improve --secmark,--id,--zone parser
      conntrack: improve --mark parser
      conntrackd: restrict multicast reception
      conntrackd: remove double close() in multicast resulting in EBADFD
      conntrackd: update netns test to support IPv6
      conntrack-tools 1.4.9 release

Pfeil Daniel (1):
      conntrackd: helpers/rpc: Don't add expectation table entry for portmap port

Phil Sutter (3):
      conntrack: Fix for ENOENT in mnl_nfct_delete_cb()
      src: Eliminate warnings with -Wcalloc-transposed-args
      nfct: helper: Extend error message for EBUSY

Stephan Brunner (1):
      conntrack: tcp: fix parsing of tuple-port-src and tuple-port-dst

Xavier Claude (1):
      conntrackd.conf.5: fix typos


--nXqxhrFKglGDWqSA--
