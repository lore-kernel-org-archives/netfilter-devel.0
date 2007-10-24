From: Greg <j.greg.k@gmail.com>
Subject: asking external app for true/false value prior to opening a new session
Date: Wed, 24 Oct 2007 07:54:33 -0500
Message-ID: <12445fff0710240554v47f2eac5q68dfa0df3af42c93@mail.gmail.com>
References: <12445fff0710150527u5e368a3cr4c81b2a6e0d579b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:52078 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXJXMyd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:54:33 -0400
Received: by rv-out-0910.google.com with SMTP id k20so156641rvb
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Oct 2007 05:54:33 -0700 (PDT)
In-Reply-To: <12445fff0710150527u5e368a3cr4c81b2a6e0d579b0@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Is there a way to create a rule that will ask an external application for a
true or false value before allowing a new connection to be established?

My idea is to simply not allow the incoming connection via the
firewall until a two-factored connection has been validated. This way
I am not restricted to what few two factor agents the vendor(s) have
based on their application support.

thanks
