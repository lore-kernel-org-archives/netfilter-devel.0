From: "Balaji Venkatamohan" <bvenkat@ncsu.edu>
Subject: how to use regex inside new netfilter extension modules?
Date: Wed, 3 Mar 2010 13:41:56 -0500 (EST)
Message-ID: <63409.152.14.240.190.1267641716.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from uni11mr.unity.ncsu.edu ([152.1.224.170]:55324 "EHLO
	uni11mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0CCSl7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:41:59 -0500
Received: from uni27wi.unity.ncsu.edu (uni27wi.unity.ncsu.edu [152.1.227.132])
	by uni11mr.unity.ncsu.edu (8.13.7/8.13.8/Nv5.2008.0610.1) with ESMTP id o23IfvoD003214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 3 Mar 2010 13:41:58 -0500 (EST)
Received: from uni27wi.unity.ncsu.edu (localhost.localdomain [127.0.0.1])
	by uni27wi.unity.ncsu.edu (8.13.8/8.13.8) with ESMTP id o23Ifuol010004
	for <netfilter-devel@vger.kernel.org>; Wed, 3 Mar 2010 13:41:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

I need to use regular expressions inside the point of decision match
function. I could not use 'regex.h ' or any other standard C library
inside any of xt_*.c or xt_c*.h files. I could also see that none of the
netfilter match extensions have them. I would also like to know why is it
so?

Is there already any regular expression definitions defined in any of
linux modules?

Thanks,
Balaji
