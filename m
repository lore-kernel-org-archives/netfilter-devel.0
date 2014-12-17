From: "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:12:15 +0000
Message-ID: <f81a9a60cf544414cb19986286b07a8f@mail.higgsboson.tk>
References: <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
 <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Development Mailing list"
	<netfilter-devel@vger.kernel.org>
To: "Arturo Borrero Gonzalez" <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:35540 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQVMQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:12:16 -0500
In-Reply-To: <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> You are making lot of assumptions, for example the '.rules' suffix.

Having some identifier is actually useful for administrators, this way you can just use 

$ mv /etc/nftables/{some.rules,some.rules-disabled}

to disable rules. Having an extension also allow editors to provide syntax highlighting.
