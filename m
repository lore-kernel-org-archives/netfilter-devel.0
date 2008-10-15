From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 1/3] Drop useless constraints
Date: Wed, 15 Oct 2008 11:50:12 +0200
Message-ID: <1224064214-9074-2-git-send-email-chifflier@inl.fr>
References: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:46710 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYJOKGm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:06:42 -0400
In-Reply-To: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 doc/pgsql-ulogd2.sql |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 78c06b5..9340801 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -109,9 +109,6 @@ CREATE TABLE tcp (
 CREATE INDEX tcp_sport ON tcp(tcp_sport);
 CREATE INDEX tcp_dport ON tcp(tcp_dport);
 
-ALTER TABLE tcp ADD CONSTRAINT tcp_sport_ok CHECK(tcp_sport >= 0 AND tcp_sport <= 65536);
-ALTER TABLE tcp ADD CONSTRAINT tcp_dport_ok CHECK(tcp_dport >= 0 AND tcp_dport <= 65536);
-
 CREATE TABLE udp (
   _udp_id bigint PRIMARY KEY UNIQUE NOT NULL,
   udp_sport integer default NULL,
@@ -122,9 +119,6 @@ CREATE TABLE udp (
 CREATE INDEX udp_sport ON udp(udp_sport);
 CREATE INDEX udp_dport ON udp(udp_dport);
 
-ALTER TABLE udp ADD CONSTRAINT udp_sport_ok CHECK(udp_sport >= 0 AND udp_sport <= 65536);
-ALTER TABLE udp ADD CONSTRAINT udp_dport_ok CHECK(udp_dport >= 0 AND udp_dport <= 65536);
-
 CREATE TABLE icmp (
   _icmp_id bigint PRIMARY KEY UNIQUE NOT NULL,
   icmp_type smallint default NULL,
-- 
1.5.6.5

