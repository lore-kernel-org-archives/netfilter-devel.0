Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD5AC0032E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 12:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377079AbjJTMSG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 08:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376941AbjJTMSF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 08:18:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE77112;
        Fri, 20 Oct 2023 05:18:02 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SBk9d0hJ8z6K7GW;
        Fri, 20 Oct 2023 20:17:25 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 20 Oct 2023 13:17:58 +0100
Message-ID: <a9c0a00a-6dd1-a11e-4c21-576c3f147f38@huawei.com>
Date:   Fri, 20 Oct 2023 15:17:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v13 12/12] landlock: Document Landlock's network support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-13-konstantin.meskhidze@huawei.com>
 <20231017.Saiw5quoo5wa@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231017.Saiw5quoo5wa@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/18/2023 3:34 PM, Mickaël Salaün пишет:
> On Mon, Oct 16, 2023 at 09:50:30AM +0800, Konstantin Meskhidze wrote:
>> Describe network access rules for TCP sockets. Add network access
>> example in the tutorial. Add kernel configuration support for network.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> Link: https://lore.kernel.org/r/20230920092641.832134-13-konstantin.meskhidze@huawei.com
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> ---
>> 
>> Changes since v12:
>> * None.
>> 
>> Changes since v11:
>> * Fixes documentaion as suggested in Günther's and Mickaёl's reviews:
>> https://lore.kernel.org/netdev/3ad02c76-90d8-4723-e554-7f97ef115fc0@digikod.net/
>> 
>> Changes since v10:
>> * Fixes documentaion as Mickaёl suggested:
>> https://lore.kernel.org/linux-security-module/ec23be77-566e-c8fd-179e-f50e025ac2cf@digikod.net/
>> 
>> Changes since v9:
>> * Minor refactoring.
>> 
>> Changes since v8:
>> * Minor refactoring.
>> 
>> Changes since v7:
>> * Fixes documentaion logic errors and typos as Mickaёl suggested:
>> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/
>> 
>> Changes since v6:
>> * Adds network support documentaion.
>> 
>> ---
>>  Documentation/userspace-api/landlock.rst | 87 ++++++++++++++++++------
>>  1 file changed, 66 insertions(+), 21 deletions(-)
>> 
>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
>> index f6a7da21708a..affadd9ac662 100644
>> --- a/Documentation/userspace-api/landlock.rst
>> +++ b/Documentation/userspace-api/landlock.rst
>> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>>  :Date: October 2022
>> 
>>  The goal of Landlock is to enable to restrict ambient rights (e.g. global
>> -filesystem access) for a set of processes.  Because Landlock is a stackable
>> -LSM, it makes possible to create safe security sandboxes as new security layers
>> -in addition to the existing system-wide access-controls. This kind of sandbox
>> -is expected to help mitigate the security impact of bugs or
>> +filesystem or network access) for a set of processes.  Because Landlock
>> +is a stackable LSM, it makes possible to create safe security sandboxes as new
>> +security layers in addition to the existing system-wide access-controls. This
>> +kind of sandbox is expected to help mitigate the security impact of bugs or
>>  unexpected/malicious behaviors in user space applications.  Landlock empowers
>>  any process, including unprivileged ones, to securely restrict themselves.
>> 
>> @@ -28,20 +28,34 @@ appropriately <kernel_support>`.
>>  Landlock rules
>>  ==============
>> 
>> -A Landlock rule describes an action on an object.  An object is currently a
>> -file hierarchy, and the related filesystem actions are defined with `access
>> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
>> +A Landlock rule describes an action on an object which the process intends to
>> +perform.  A set of rules is aggregated in a ruleset, which can then restrict
>>  the thread enforcing it, and its future children.
>> 
>> +The two existing types of rules are:
>> +
>> +Filesystem rules
>> +    For these rules, the object is a file hierarchy,
>> +    and the related filesystem actions are defined with
>> +    `filesystem access rights`.
>> +
>> +Network rules (since ABI v4)
>> +    For these rules, the object is currently a TCP port,
>> +    and the related actions are defined with `network access rights`.
>> +
>>  Defining and enforcing a security policy
>>  ----------------------------------------
>> 
>> -We first need to define the ruleset that will contain our rules.  For this
>> -example, the ruleset will contain rules that only allow read actions, but write
>> -actions will be denied.  The ruleset then needs to handle both of these kind of
>> -actions.  This is required for backward and forward compatibility (i.e. the
>> -kernel and user space may not know each other's supported restrictions), hence
>> -the need to be explicit about the denied-by-default access rights.
>> +We first need to define the ruleset that will contain our rules.
>> +
>> +For this example, the ruleset will contain rules that only allow filesystem
>> +read actions and establish a specific TCP connection. Filesystem write
>> +actions and other TCP actions will be denied.
>> +
>> +The ruleset then needs to handle both of these kind of actions.  This is
> 
> two spelling issues:
> "needs to handle both these kinds of actions."

   Thanks. Will be updated.
> 
>> +required for backward and forward compatibility (i.e. the kernel and user
>> +space may not know each other's supported restrictions), hence the need
>> +to be explicit about the denied-by-default access rights.
>> 
>>  .. code-block:: c
>> 
>> @@ -62,6 +76,9 @@ the need to be explicit about the denied-by-default access rights.
>>              LANDLOCK_ACCESS_FS_MAKE_SYM |
>>              LANDLOCK_ACCESS_FS_REFER |
>>              LANDLOCK_ACCESS_FS_TRUNCATE,
>> +        .handled_access_net =
>> +            LANDLOCK_ACCESS_NET_BIND_TCP |
>> +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>      };
>> 
>>  Because we may not know on which kernel version an application will be
>> @@ -70,9 +87,7 @@ should try to protect users as much as possible whatever the kernel they are
>>  using.  To avoid binary enforcement (i.e. either all security features or
>>  none), we can leverage a dedicated Landlock command to get the current version
>>  of the Landlock ABI and adapt the handled accesses.  Let's check if we should
>> -remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE``
>> -access rights, which are only supported starting with the second and third
>> -version of the ABI.
>> +remove access rights which are only supported in higher versions of the ABI.
>> 
>>  .. code-block:: c
>> 
>> @@ -92,6 +107,11 @@ version of the ABI.
>>      case 2:
>>          /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>>          ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
> 
> Like just before "case 2" this is missing:
> __attribute__((fallthrough));

   Yep. Will be added.
> 
>> +    case 3:
>> +        /* Removes network support for ABI < 4 */
>> +        ruleset_attr.handled_access_net &=
>> +            ~(LANDLOCK_ACCESS_NET_BIND_TCP |
>> +              LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>      }
>> 
>>  This enables to create an inclusive ruleset that will contain our rules.
>> @@ -143,10 +163,23 @@ for the ruleset creation, by filtering access rights according to the Landlock
>>  ABI version.  In this example, this is not required because all of the requested
>>  ``allowed_access`` rights are already available in ABI 1.
>> 
>> -We now have a ruleset with one rule allowing read access to ``/usr`` while
>> -denying all other handled accesses for the filesystem.  The next step is to
>> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
>> -binary).
>> +For network access-control, we can add a set of rules that allow to use a port
>> +number for a specific action: HTTPS connections.
>> +
>> +.. code-block:: c
>> +
>> +    struct landlock_net_port_attr net_port = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +        .port = 443,
>> +    };
>> +
>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +                            &net_port, 0);
>> +
>> +The next step is to restrict the current thread from gaining more privileges
>> +(e.g. through a SUID binary). We now have a ruleset with the first rule allowing
>> +read access to ``/usr`` while denying all other handled accesses for the filesystem,
>> +and a second rule allowing HTTPS connections.
>> 
>>  .. code-block:: c
>> 
>> @@ -355,7 +388,7 @@ Access rights
>>  -------------
>> 
>>  .. kernel-doc:: include/uapi/linux/landlock.h
>> -    :identifiers: fs_access
>> +    :identifiers: fs_access net_access
>> 
>>  Creating a new ruleset
>>  ----------------------
>> @@ -374,6 +407,7 @@ Extending a ruleset
>> 
>>  .. kernel-doc:: include/uapi/linux/landlock.h
>>      :identifiers: landlock_rule_type landlock_path_beneath_attr
>> +                  landlock_net_service_attr
> 
> landlock_net_port_attr
> 
>> 
>>  Enforcing a ruleset
>>  -------------------
>> @@ -451,6 +485,12 @@ always allowed when using a kernel that only supports the first or second ABI.
>>  Starting with the Landlock ABI version 3, it is now possible to securely control
>>  truncation thanks to the new ``LANDLOCK_ACCESS_FS_TRUNCATE`` access right.
>> 
>> +Network support (ABI < 4)
>> +-------------------------
>> +
>> +Starting with the Landlock ABI version 4, it is now possible to restrict TCP
>> +bind and connect actions to only a set of allowed ports.
> 
> bind and connect actions to only a set of allowed ports thanks to the new
> ``LANDLOCK_ACCESS_NET_BIND_TCP`` and ``LANDLOCK_ACCESS_NET_CONNECT_TCP``
> access rights.

  OK. Thanks.
> 
>> +
>>  .. _kernel_support:
>> 
>>  Kernel support
>> @@ -469,6 +509,11 @@ still enable it by adding ``lsm=landlock,[...]`` to
>>  Documentation/admin-guide/kernel-parameters.rst thanks to the bootloader
>>  configuration.
>> 
>> +To be able to explicitly allow TCP operations (e.g., adding a network rule with
>> +``LANDLOCK_ACCESS_NET_TCP_BIND``), the kernel must support TCP (``CONFIG_INET=y``).
> 
> LANDLOCK_ACCESS_NET_BIND_TCP

   OK. Got it.
> 
>> +Otherwise, sys_landlock_add_rule() returns an ``EAFNOSUPPORT`` error, which can
>> +safely be ignored because this kind of TCP operation is already not possible.
>> +
>>  Questions and answers
>>  =====================
>> 
>> --
>> 2.25.1
>> 
> .
