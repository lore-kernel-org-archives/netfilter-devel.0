Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC50358D11;
	Tue, 18 Nov 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473637; cv=none; b=ZPCoLfYPnKNfyXvMKIgS6cS3TMuRWqxFyRzzAEPNbivWP7UObhKPhIdiPNgHwjDPRcUAqmyNjKBV7HSKqbLzy3wgGwKdOvHEG3ONq+fYYiP6mFEEy2a+6L2RqArzssW9zGCWV7HagwnNEnIkZ+hxgmUZ2DN1FpXW55rQ9X/fIH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473637; c=relaxed/simple;
	bh=9LsR1sVmTcxFSzMrb0BVLV7ghy87Yimdmp8ZgQOctjQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhPL3WXwGJUIJKS86ZvG2M0jrmhpMFD0YyRDMO8J7hgBHjYNuGOYtF9f/1bHWkY+eKUkpBoSlXcDNi+plRgVQ1A4GaMqY6KzGnYgY9Nn/q7JbZa2wLSgxsUHDCO1srxwwnTDUWR5ywceh3FdR0YOELIdwlE1OZbujYTLneCLTnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9m28d4zHnH7f;
	Tue, 18 Nov 2025 21:46:36 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 35B661402F3;
	Tue, 18 Nov 2025 21:47:07 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:06 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 19/19] landlock: Document socket rule type support
Date: Tue, 18 Nov 2025 21:46:39 +0800
Message-ID: <20251118134639.3314803-20-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Extend documentation with socket rule type description.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Fixes identantion.
---
 Documentation/userspace-api/landlock.rst | 48 ++++++++++++++++++++----
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
index 1d0c2c15c22e..49fdc897db24 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -8,7 +8,7 @@ Landlock: unprivileged access control
 =====================================
 
 :Author: Mickaël Salaün
-:Date: March 2025
+:Date: November 2025
 
 The goal of Landlock is to enable restriction of ambient rights (e.g. global
 filesystem or network access) for a set of processes.  Because Landlock
@@ -33,7 +33,7 @@ A Landlock rule describes an action on an object which the process intends to
 perform.  A set of rules is aggregated in a ruleset, which can then restrict
 the thread enforcing it, and its future children.
 
-The two existing types of rules are:
+The three existing types of rules are:
 
 Filesystem rules
     For these rules, the object is a file hierarchy,
@@ -44,14 +44,18 @@ Network rules (since ABI v4)
     For these rules, the object is a TCP port,
     and the related actions are defined with `network access rights`.
 
+Socket rules (since ABI v8)
+    For these rules, the object is a pair of an address family and a socket type,
+    and the related actions are defined with `socket access rights`.
+
 Defining and enforcing a security policy
 ----------------------------------------
 
 We first need to define the ruleset that will contain our rules.
 
 For this example, the ruleset will contain rules that only allow filesystem
-read actions and establish a specific TCP connection. Filesystem write
-actions and other TCP actions will be denied.
+read actions, create TCP sockets and establish a specific TCP connection.
+Filesystem write actions, non-TCP sockets creation other TCP actions will be denied.
 
 The ruleset then needs to handle both these kinds of actions.  This is
 required for backward and forward compatibility (i.e. the kernel and user
@@ -81,6 +85,8 @@ to be explicit about the denied-by-default access rights.
         .handled_access_net =
             LANDLOCK_ACCESS_NET_BIND_TCP |
             LANDLOCK_ACCESS_NET_CONNECT_TCP,
+        .handled_access_socket =
+            LANDLOCK_ACCESS_SOCKET_CREATE,
         .scoped =
             LANDLOCK_SCOPE_ABSTRACT_UNIX_SOCKET |
             LANDLOCK_SCOPE_SIGNAL,
@@ -127,6 +133,11 @@ version, and only use the available subset of access rights:
         /* Removes LANDLOCK_SCOPE_* for ABI < 6 */
         ruleset_attr.scoped &= ~(LANDLOCK_SCOPE_ABSTRACT_UNIX_SOCKET |
                                  LANDLOCK_SCOPE_SIGNAL);
+    case 6:
+    case 7:
+         /* Removes LANDLOCK_ACCESS_SOCKET for ABI < 8 */
+         ruleset_attr.handled_access_socket &=
+             ~LANDLOCK_ACCESS_SOCKET_CREATE;
     }
 
 This enables the creation of an inclusive ruleset that will contain our rules.
@@ -178,6 +189,21 @@ for the ruleset creation, by filtering access rights according to the Landlock
 ABI version.  In this example, this is not required because all of the requested
 ``allowed_access`` rights are already available in ABI 1.
 
+For socket access-control, we can add a rule to allow TCP sockets creation. UNIX,
+UDP/IP and other protocols will be denied by the ruleset.
+
+.. code-block:: c
+
+    struct landlock_net_port_attr tcp_socket = {
+        .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+        .family = AF_INET,
+        .type = SOCK_STREAM,
+        .protocol = 0,
+    };
+
+    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+                            &tcp_socket, 0);
+
 For network access-control, we can add a set of rules that allow to use a port
 number for a specific action: HTTPS connections.
 
@@ -194,7 +220,8 @@ number for a specific action: HTTPS connections.
 The next step is to restrict the current thread from gaining more privileges
 (e.g. through a SUID binary).  We now have a ruleset with the first rule
 allowing read access to ``/usr`` while denying all other handled accesses for
-the filesystem, and a second rule allowing HTTPS connections.
+the filesystem, a second rule allowing TCP sockets and a third rule allowing
+HTTPS connections.
 
 .. code-block:: c
 
@@ -442,7 +469,7 @@ Access rights
 -------------
 
 .. kernel-doc:: include/uapi/linux/landlock.h
-    :identifiers: fs_access net_access scope
+    :identifiers: fs_access net_access socket_access scope
 
 Creating a new ruleset
 ----------------------
@@ -461,7 +488,7 @@ Extending a ruleset
 
 .. kernel-doc:: include/uapi/linux/landlock.h
     :identifiers: landlock_rule_type landlock_path_beneath_attr
-                  landlock_net_port_attr
+                  landlock_net_port_attr landlock_socket_attr
 
 Enforcing a ruleset
 -------------------
@@ -604,6 +631,13 @@ Landlock audit events with the ``LANDLOCK_RESTRICT_SELF_LOG_SAME_EXEC_OFF``,
 sys_landlock_restrict_self().  See Documentation/admin-guide/LSM/landlock.rst
 for more details on audit.
 
+Socket support (ABI < 8)
+-------------------------
+
+Starting with the Landlock ABI version 8, it is now possible to restrict
+creation of user space sockets to only a set of allowed protocols thanks
+to the new ``LANDLOCK_ACCESS_SOCKET_CREATE`` access right.
+
 .. _kernel_support:
 
 Kernel support
-- 
2.34.1

