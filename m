Received: from mail-4323.protonmail.ch (mail-4323.protonmail.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65ED21C161
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752086382; cv=none; b=bcfAHIdGXiGhJQBJPVtuipZPALuZHHk0THO+arj3cfmXLgILxoNBOpRhMA7AUiAPjuyC2+rOTCIjED4Gv2HwDatNAeHM2azzB9SB+D1Ss3bBomtixg5vPbobzsx2m7Mtaui4mdVZ0quFf+Uae806oQrJCm8sY44/xywHLpPXa5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752086382; c=relaxed/simple;
	bh=Fji6DNE7UjFCPkG+IxzWnQQFtdW0Iq4Je2nw5U+DEPE=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=Os7YnfRHj7rqRx1a+t/zjk5cTlA4a5unCeyz7kOoljmYfv5L+w4qMCtcW1/HrEqd7ItrDds4eKUQNzpAJaOJ/IRCoxdNtYkrCNkMwA13wUjTgcAiEPzCVbc4G9UHCSKxb32MMV71AfM4WR5DZ1CiEBPhuP6iM9g1zwkzgg/hN60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xavierclaude.be; spf=pass smtp.mailfrom=xavierclaude.be; dkim=pass (2048-bit key) header.d=xavierclaude.be header.i=@xavierclaude.be header.b=K3JkQ4/Q; arc=none smtp.client-ip=185.70.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xavierclaude.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xavierclaude.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xavierclaude.be header.i=@xavierclaude.be header.b="K3JkQ4/Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xavierclaude.be;
	s=protonmail3; t=1752086367; x=1752345567;
	bh=oYzM4axQ/DE02Zub7YW8wdvHsEmXmKtihYyDXyOFdt0=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=K3JkQ4/QscaGMCclR566IgmDWMYy3Ou8/HwPiZ4TBwio6LRsjbCaZ2+sRkslwMcn3
	 8zk3gGBGS0Ix5T561RqoNtcgU1NCpsMv9s6p2v/AbFjclRyb0myfbAq47YohuGR05K
	 5uyJitfS4440LcZ4MUSlxaZ1OyfNjFESnKVNhrIxKeD7CDPb31kv0ZGeapAsdd4xLi
	 vQrpd6RfmvfTa9OyaBIfZurvk7QCsE+f45DF/lwrh8JifwTm3yMNrjqai1jCXIB81A
	 3wfmgXQ1V4cq1zDYVmsHMIhUtCoTonFTikRCAUTTkhKcjOzxXmWPS9Jrk51giRoYTw
	 4xC7sYJnD2OVQ==
Date: Wed, 09 Jul 2025 18:39:20 +0000
To: netfilter-devel@vger.kernel.org
From: Xavier Claude <contact@xavierclaude.be>
Subject: [PATCH conntrack-tools] Typo in contrackd-conf manpage
Message-ID: <3365321.aeNJFYEL58@kashyyk>
Feedback-ID: 36077759:user:proton
X-Pm-Message-ID: a97bf635b5407e40ca6a12a90d59ce6bff75185a
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I've found a few typos in the conntrackd.conf.5 manpage.
I hope it's the right mailing list for this kind of  report.
-- >8 --

Fixes some small typos on the conf file manpage. Acknowledegement is not a =
typo
per se, but I've uniformized the spelling to use the same everywhere.

Signed-off-by: Xavier Claude <contact@xavierclaude.be>
---
 conntrackd.conf.5 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 50d7b98..fbb75e3 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -84,7 +84,7 @@ In this synchronization mode you may configure=20
\fBResendQueueSize\fP,
 .TP
 .BI "ResendQueueSize <value>"
 Size of the resend queue (in objects). This is the maximum number of objec=
ts
-that can be stored waiting to be confirmed via acknoledgment.
+that can be stored waiting to be confirmed via acknowledgment.
 If you keep this value low, the daemon will have less chances to recover
 state-changes under message omission. On the other hand, if you keep this=
=20
value
 high, the daemon will consume more memory to store dead objects.
@@ -120,8 +120,8 @@ Default is 60 seconds.
=20
 .TP
 .BI "ACKWindowSize <value>"
-Set the acknowledgement window size. If you decrease this value, the numbe=
r=20
of
-acknowlegdments increases. More acknowledgments means more overhead as
+Set the acknowledgment window size. If you decrease this value, the number=
 of
+acknowledgments increases. More acknowledgments means more overhead as
 \fBconntrackd(8)\fP has to handle more control messages. On the other hand=
,=20
if
 you increase this value, the resend queue gets more populated. This result=
s=20
in
 more overhead in the queue releasing.
@@ -334,7 +334,7 @@ fault-tolerance. In case of doubt, use it.
 This section indicates to \fBconntrackd(8)\fP to use UDP as transport
 mechanism between nodes of the firewall cluster.
=20
-As in the \fBMulticast\fP configuration, you may especify several fail-ove=
r
+As in the \fBMulticast\fP configuration, you may specify several fail-over
 dedicated links using the \fIDefault\fP keyword.
=20
 Example:
@@ -407,7 +407,7 @@ If you combine this transport with the \fBNOTRACK\fP mo=
de,=20
it becomes reliable.
 The TCP transport protocol can be configured in exactly the same way as
 the \fBUDP\fP transport protocol.
=20
-As in the \fBMulticast\fP configuration, you may especify several fail-ove=
r
+As in the \fBMulticast\fP configuration, you may specify several fail-over
 dedicated links using the \fIDefault\fP keyword.
=20
 Example:
--=20
2.50.0





