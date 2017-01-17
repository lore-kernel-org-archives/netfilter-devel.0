From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 1/2] doc: Include stateless option
Date: Tue, 17 Jan 2017 13:39:34 -0200
Message-ID: <20170117153933.GA31230@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33498 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdAQPkQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 10:40:16 -0500
Received: by mail-vk0-f66.google.com with SMTP id t8so5210389vke.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2017 07:39:41 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 doc/nft.xml | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index a421278..78e112f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -49,6 +49,9 @@ vi:ts=4 sw=4
 				<option>-n | --numeric</option>
 			</arg>
 			<arg choice="opt">
+				<option>-s | --stateless</option>
+			</arg>
+			<arg choice="opt">
 				<option>[-I | --includepath]</option>
 				<replaceable>directory</replaceable>
 			</arg>
@@ -119,6 +122,14 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
+				<term><option>-s, --stateless</option></term>
+				<listitem>
+					<para>
+						Omit stateful information of rules and stateful objects.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
 				<term><option>-N</option></term>
 				<listitem>
 					<para>
-- 
2.7.4

