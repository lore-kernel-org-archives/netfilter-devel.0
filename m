From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 3/3] doc: Document add / delete element operations of
 sets and maps
Date: Fri, 17 Mar 2017 12:04:48 -0300
Message-ID: <20170317150448.GA1318@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35412 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdCQPGF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 11:06:05 -0400
Received: by mail-qt0-f193.google.com with SMTP id r5so9812145qtb.2
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 08:05:09 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The add / delete operations weren't documented yet. They fit better
in the sets and maps blocks since these operations are used to directly
modify their content.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 doc/nft.xml | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index a63b4c2..9624703 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -697,6 +697,19 @@ filter input iif $int_ifs accept
 				<arg choice="req"><replaceable>table</replaceable></arg>
 				<arg choice="req"><replaceable>set</replaceable></arg>
 			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>add</arg>
+					<arg>delete</arg>
+				</group>
+				<command> element</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>set</replaceable></arg>
+				{
+				<arg choice="req"><replaceable>elements</replaceable></arg>
+				}
+			</cmdsynopsis>
 		</para>
 		<para>
 			Sets are elements containers of an user-defined data type, they are uniquely identified by an user-defined name and attached to tables.
@@ -735,6 +748,22 @@ filter input iif $int_ifs accept
 					</para>
 				</listitem>
 			</varlistentry>
+			<varlistentry>
+				<term><option>add element</option></term>
+				<listitem>
+					<para>
+						Comma-separated list of elements to add into the specified set.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>delete element</option></term>
+				<listitem>
+					<para>
+						Comma-separated list of elements to delete from the specified set.
+					</para>
+				</listitem>
+			</varlistentry>
 		</variablelist>
 
 		<table frame="all">
@@ -819,6 +848,19 @@ filter input iif $int_ifs accept
 				<arg choice="req"><replaceable>table</replaceable></arg>
 				<arg choice="req"><replaceable>map</replaceable></arg>
 			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>add</arg>
+					<arg>delete</arg>
+				</group>
+				<command> element</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>map</replaceable></arg>
+				{
+				<arg choice="req"><replaceable>elements</replaceable></arg>
+				}
+			</cmdsynopsis>
 		</para>
 		<para>
 			Maps store data based on some specific key used as input, they are uniquely identified by an user-defined name and attached to tables.
@@ -857,6 +899,22 @@ filter input iif $int_ifs accept
 					</para>
 				</listitem>
 			</varlistentry>
+			<varlistentry>
+				<term><option>add element</option></term>
+				<listitem>
+					<para>
+						Comma-separated list of elements to add into the specified map.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>delete element</option></term>
+				<listitem>
+					<para>
+						Comma-separated list of element keys to delete from the specified map.
+					</para>
+				</listitem>
+			</varlistentry>
 		</variablelist>
 
 		<table frame="all">
-- 
2.7.4

