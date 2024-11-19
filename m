Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [24.116.100.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987AC1CC88B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=24.116.100.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033192; cv=none; b=CGrBDzmePbFhOCJTz71A2bhDfJAsW7BQbkKuZgPWDQijzs9KKMkY/mNG4RR35ffTbfnPdYPBShTl51iujcRzW6SQYVvjN1YrIVpdW7Zve/kILy2+D8qqF1IeX0xq1kMacTSA08mlea5/y3f3bYNUgRVrSeKF/KDo5zFlK7tJyVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033192; c=relaxed/simple;
	bh=s3j1Jd9cGynGCkN0Zs7iy29GOzpS/JqxU0dgLQ87ojY=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=Vr2E2wLyn7FdeETEXYfT/9DgXjNySfCsDYWrlLB6QN+KL00pUXQVOVeWsSYqlg19MmeqVOVoGFCdebL7KT0eFh94lRSTBhnkXxI9++qpXeDtF4cVdvFuiXUds+vLShU1uML9cHghOBAbwsyyuSroeteHVEnCBe7xcsXcZnSpqRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com; spf=pass smtp.mailfrom=redfish-solutions.com; arc=none smtp.client-ip=24.116.100.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redfish-solutions.com
Received: from smtpclient.apple (Macmini2-51.redfish-solutions.com [192.168.8.9])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.17.2/8.16.1) with ESMTPSA id 4AJGCi5l157511
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 09:12:44 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Testing for xt_REDIRECT
Message-Id: <C5BF9F7A-EA10-42DA-BE7E-B5B03CD5744A@redfish-solutions.com>
Date: Tue, 19 Nov 2024 09:12:34 -0700
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3826.200.121)
X-Scanned-By: MIMEDefang 3.4.1 on 192.168.8.3

Hi,

Is there a way to detect if a packet has already gone through -j =
REDIRECT?  Is there a test that indicates this?

Thanks

