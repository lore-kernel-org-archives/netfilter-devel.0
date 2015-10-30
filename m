From: Loganaden Velvindron <logan@elandsys.com>
Subject: Re: [PATCH 1/1] use vzalloc() instead of vmalloc() for counterstmp
Date: Fri, 30 Oct 2015 09:22:36 -0700
Message-ID: <20151030162236.GA24046@mx.elandsys.com>
References: <20151030123013.GA11246@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:49924 "EHLO mx.elandsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbbJ3QWi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2015 12:22:38 -0400
Received: from mx.elandsys.com (IDENT:logan@localhost [127.0.0.1])
	by mx.elandsys.com (8.14.5/8.14.5) with ESMTP id t9UGMaM9008178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2015 09:22:37 -0700 (PDT)
Received: (from logan@localhost)
	by mx.elandsys.com (8.14.5/8.14.5/Submit) id t9UGMaaM020199
	for netfilter-devel@vger.kernel.org; Fri, 30 Oct 2015 09:22:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151030123013.GA11246@mx.elandsys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please discard this one as the subject is not formatted correctly.
